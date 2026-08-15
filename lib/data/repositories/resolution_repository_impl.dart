import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/context_node.dart';
import '../../domain/entities/memory_evidence.dart';
import '../../domain/entities/pending_resolution.dart';
import '../../domain/entities/processing_status.dart';
import '../../domain/repositories/context_repository.dart';
import '../../domain/repositories/evidence_repository.dart';
import '../../domain/repositories/resolution_repository.dart';
import '../local/database/app_database.dart';

class ResolutionRepositoryImpl implements ResolutionRepository {
  ResolutionRepositoryImpl({
    required AppDatabase db,
    required ContextRepository contextRepository,
    required EvidenceRepository evidenceRepository,
  })  : _db = db,
        _contextRepository = contextRepository,
        _evidenceRepository = evidenceRepository;

  final AppDatabase _db;
  final ContextRepository _contextRepository;
  final EvidenceRepository _evidenceRepository;
  final _uuid = const Uuid();

  @override
  Stream<List<PendingResolution>> watchPendingResolutions() {
    return _db.pendingResolutions.watchPending().map(
          (rows) => rows.map(_rowToResolution).toList(),
        );
  }

  @override
  Future<List<PendingResolution>> getAllPending() async {
    final rows = await _db.pendingResolutions.getAllPending();
    return rows.map(_rowToResolution).toList();
  }

  @override
  Future<PendingResolution?> getPendingByMemoryId(String memoryId) async {
    final row = await _db.pendingResolutions.getByMemoryId(memoryId);
    return row == null ? null : _rowToResolution(row);
  }

  @override
  Future<void> savePendingResolution(PendingResolution resolution) async {
    final candidatesJson =
        jsonEncode(resolution.candidates.map((c) => c.toJson()).toList());

    await _db.pendingResolutions.insertResolution(
      PendingResolutionsTableCompanion.insert(
        id: resolution.id,
        memoryId: resolution.memoryId,
        noteTextSnippet: Value(resolution.noteTextSnippet),
        candidatesJson: Value(candidatesJson),
        status: Value(resolution.status),
        selectedContextId: Value(resolution.selectedContextId),
        resolutionSource: Value(resolution.resolutionSource?.name),
        createdAt: resolution.createdAt.millisecondsSinceEpoch,
        resolvedAt: Value(resolution.resolvedAt?.millisecondsSinceEpoch),
      ),
    );

    // Mark note processing status as needsUserClarification
    await (_db.update(_db.notesTable)
          ..where((t) => t.id.equals(resolution.memoryId)))
        .write(
      NotesTableCompanion(
        processingStatus: Value(ProcessingStatus.needsUserClarification.name),
      ),
    );
  }

  @override
  Future<void> resolveResolution({
    required String resolutionId,
    required String memoryId,
    required ResolutionChoice choice,
  }) async {
    final now = DateTime.now();
    final resolution = await _db.pendingResolutions.getById(resolutionId);
    final candidateOptions = resolution != null
        ? _parseCandidates(resolution.candidatesJson)
        : <ResolutionCandidateOption>[];

    String? selectedTargetId;
    ResolutionSource source = ResolutionSource.userConfirmed;

    if (choice.isSingle && choice.contextId != null) {
      selectedTargetId = choice.contextId;
      final targetContext = await _contextRepository.getNodeById(choice.contextId!);
      final contextName = targetContext?.name ?? 'Context';

      // 1. Link memory to confirmed context
      await _contextRepository.linkMemory(MemoryContextLink(
        memoryId: memoryId,
        contextId: choice.contextId!,
        role: 'user_confirmed',
        confidence: 1.0,
        evidence: 'User explicitly confirmed context "$contextName".',
        createdAt: now,
      ));

      // 2. Save Evidence with highest authority
      await _evidenceRepository.saveEvidence(MemoryEvidence(
        id: _uuid.v4(),
        sourceMemoryId: memoryId,
        sourceTextSnippet: resolution?.noteTextSnippet ?? '',
        targetContextId: choice.contextId!,
        targetContextName: contextName,
        relationType: 'user_confirmed',
        confidence: 1.0,
        inferenceType: InferenceType.explicit,
        signals: [
          const EvidenceSignal(
            signalType: SignalType.explicitMention,
            weight: 1.0,
            score: 1.0,
            description: 'User confirmed context assignment',
          ),
        ],
        explanation: 'User confirmed that this memory belongs to "$contextName".',
        createdAt: now,
      ));
    } else if (choice.isBoth) {
      source = ResolutionSource.userConfirmed;
      for (final candidate in candidateOptions) {
        await _contextRepository.linkMemory(MemoryContextLink(
          memoryId: memoryId,
          contextId: candidate.contextId,
          role: 'user_confirmed_multi',
          confidence: 1.0,
          evidence: 'User confirmed multi-context binding to "${candidate.contextName}".',
          createdAt: now,
        ));
      }
      if (candidateOptions.isNotEmpty) {
        selectedTargetId = candidateOptions.first.contextId;
      }
    } else if (choice.isNewContext && choice.newContextName != null) {
      source = ResolutionSource.manual;
      final newId = 'ctx-user-${_uuid.v4().substring(0, 8)}';
      final newContext = ContextNode(
        id: newId,
        name: choice.newContextName!,
        type: ContextNodeType.fromString(choice.newContextType ?? 'project'),
        originatingMemoryId: memoryId,
        createdAt: now,
        updatedAt: now,
      );

      await _contextRepository.upsertNode(newContext);
      await _contextRepository.linkMemory(MemoryContextLink(
        memoryId: memoryId,
        contextId: newId,
        role: 'created_context',
        confidence: 1.0,
        evidence: 'User created new context "${choice.newContextName}".',
        createdAt: now,
      ));
      selectedTargetId = newId;
    } else if (choice.isNone) {
      source = ResolutionSource.userRejected;
    }

    // 3. Mark resolution as resolved in DB
    await _db.pendingResolutions.markResolved(
      id: resolutionId,
      selectedContextId: selectedTargetId,
      source: source.name,
      resolvedAt: now.millisecondsSinceEpoch,
    );

    // 4. Update note processing status to completed
    await (_db.update(_db.notesTable)..where((t) => t.id.equals(memoryId))).write(
      NotesTableCompanion(
        processingStatus: Value(ProcessingStatus.completed.name),
        updatedAt: Value(now.millisecondsSinceEpoch),
      ),
    );
  }

  @override
  Future<void> deleteByMemoryId(String memoryId) {
    return _db.pendingResolutions.deleteByMemoryId(memoryId);
  }

  PendingResolution _rowToResolution(PendingResolutionsTableData row) {
    final candidates = _parseCandidates(row.candidatesJson);

    return PendingResolution(
      id: row.id,
      memoryId: row.memoryId,
      noteTextSnippet: row.noteTextSnippet,
      candidates: candidates,
      status: row.status,
      selectedContextId: row.selectedContextId,
      resolutionSource: row.resolutionSource != null
          ? ResolutionSource.fromString(row.resolutionSource!)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      resolvedAt: row.resolvedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(row.resolvedAt!)
          : null,
    );
  }

  List<ResolutionCandidateOption> _parseCandidates(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((c) => ResolutionCandidateOption.fromJson(c))
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
