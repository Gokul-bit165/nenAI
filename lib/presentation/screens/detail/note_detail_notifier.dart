import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/entities/context_node.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../domain/repositories/context_repository.dart';
import '../../../data/local/database/app_database.dart';
import '../../../injection.dart';
import '../../components/memory_understanding_card.dart';

final noteDetailProvider = StreamProvider.family.autoDispose<Note?, String>((ref, noteId) async* {
  final repository = getIt<NoteRepository>();
  await for (final notes in repository.watchAllNotes()) {
    final match = notes.where((n) => n.id == noteId).firstOrNull;
    yield match;
  }
});

final relatedNotesProvider = FutureProvider.family.autoDispose<List<Note>, List<String>>((ref, relatedIds) async {
  if (relatedIds.isEmpty) return [];
  final repository = getIt<NoteRepository>();
  final notes = <Note>[];
  for (final id in relatedIds) {
    final note = await repository.getNoteById(id);
    if (note != null) notes.add(note);
  }
  return notes;
});

final noteEntitiesProvider = FutureProvider.family.autoDispose<List<EntitiesTableData>, String>((ref, noteId) async {
  final db = getIt<AppDatabase>();
  return await db.entities.getEntitiesForMemory(noteId);
});

final noteRelationshipsProvider = FutureProvider.family.autoDispose<List<({String sourceName, String relation, String targetName})>, String>((ref, noteId) async {
  final db = getIt<AppDatabase>();
  final rels = await db.relationships.getByMemoryId(noteId);
  final results = <({String sourceName, String relation, String targetName})>[];

  for (final rel in rels) {
    final source = await db.entities.getById(rel.sourceEntityId);
    final target = await db.entities.getById(rel.targetEntityId);
    if (source != null && target != null) {
      results.add((
        sourceName: source.name,
        relation: rel.relation,
        targetName: target.name,
      ));
    }
  }
  return results;
});

final noteTasksProvider = FutureProvider.family.autoDispose<List<TasksTableData>, String>((ref, noteId) async {
  final db = getIt<AppDatabase>();
  return await db.tasks.getByMemoryId(noteId);
});

class NoteUnderstandingState {
  const NoteUnderstandingState({
    required this.contextName,
    this.contextType,
    required this.pathNodes,
    this.reason,
    this.confidenceLevel = 'High',
    this.confidenceScore,
    this.evidenceSignals = const [],
    this.statusText = 'Automatically connected',
    this.isAmbiguous = false,
    this.candidateOptions = const [],
    this.pendingResolutionId,
  });

  final String contextName;
  final String? contextType;
  final List<String> pathNodes;
  final String? reason;
  final String confidenceLevel;
  final double? confidenceScore;
  final List<String> evidenceSignals;
  final String statusText;
  final bool isAmbiguous;
  final List<CandidateOption> candidateOptions;
  final String? pendingResolutionId;
}

final noteUnderstandingProvider = FutureProvider.family.autoDispose<NoteUnderstandingState, String>((ref, noteId) async {
  final db = getIt<AppDatabase>();
  final contextRepository = getIt<ContextRepository>();

  // 1. Check Pending Resolution (Ambiguous Case)
  final pending = await db.pendingResolutions.getByMemoryId(noteId);
  if (pending != null && pending.status == 'pending') {
    final candidates = <CandidateOption>[];
    try {
      final decoded = jsonDecode(pending.candidatesJson) as List<dynamic>;
      for (final item in decoded) {
        final map = item as Map<String, dynamic>;
        final score = (map['finalScore'] as num?)?.toDouble() ?? 0.5;
        candidates.add(
          CandidateOption(
            id: map['candidateId'] as String? ?? 'unknown',
            name: map['candidateName'] as String? ?? 'Context',
            scorePercent: (score * 100).round(),
            evidenceSummary: map['explanation'] as String?,
          ),
        );
      }
    } catch (_) {}

    return NoteUnderstandingState(
      contextName: 'Multiple Candidates',
      pathNodes: const [],
      reason: 'Multiple candidate contexts identified with competing confidence.',
      isAmbiguous: true,
      candidateOptions: candidates,
      pendingResolutionId: pending.id,
      statusText: 'Needs Clarification',
    );
  }

  // 2. Normal / Connected Case: Find linked context nodes
  final contexts = await contextRepository.getContextsForMemory(noteId);
  final evidenceRows = await db.evidence.getByMemoryId(noteId);

  if (contexts.isEmpty) {
    return const NoteUnderstandingState(
      contextName: 'General Memory',
      pathNodes: ['General Memory'],
      reason: 'No explicit parent context link established.',
      confidenceLevel: 'Medium',
      confidenceScore: 0.50,
      evidenceSignals: ['Standalone scratchpad note'],
      statusText: 'Saved',
    );
  }

  final primaryContext = contexts.first;
  final ancestors = await contextRepository.getAncestors(primaryContext.id);
  final pathNodes = [...ancestors.reversed.map((a) => a.name), primaryContext.name];

  String reason = 'Recent memories and entities connect this note to ${primaryContext.name}.';
  double confidence = 0.90;
  String confidenceLevel = 'High';
  final evidenceSignals = <String>[];
  String statusText = 'Automatically connected';

  if (evidenceRows.isNotEmpty) {
    final topEvidence = evidenceRows.first;
    confidence = topEvidence.confidence;
    confidenceLevel = confidence >= 0.80 ? 'High' : (confidence >= 0.50 ? 'Medium' : 'Low');
    if (topEvidence.explanation.isNotEmpty) {
      reason = topEvidence.explanation;
    }
    if (topEvidence.inferenceType == 'explicit') {
      statusText = 'User confirmed';
      confidenceLevel = 'Verified';
      confidence = 1.0;
    }

    try {
      final decodedSignals = jsonDecode(topEvidence.signalsJson) as List<dynamic>;
      for (final s in decodedSignals) {
        final sMap = s as Map<String, dynamic>;
        final desc = sMap['description'] as String?;
        if (desc != null && desc.isNotEmpty) {
          evidenceSignals.add(desc);
        }
      }
    } catch (_) {}
  }

  if (evidenceSignals.isEmpty) {
    evidenceSignals.add('${primaryContext.name} was referenced or active');
    evidenceSignals.add('Same contextual lineage (${primaryContext.type.name})');
  }

  return NoteUnderstandingState(
    contextName: primaryContext.name,
    contextType: primaryContext.type.name,
    pathNodes: pathNodes,
    reason: reason,
    confidenceLevel: confidenceLevel,
    confidenceScore: confidence,
    evidenceSignals: evidenceSignals,
    statusText: statusText,
  );
});

Future<void> resolvePendingContext(WidgetRef ref, {
  required String noteId,
  required String pendingResolutionId,
  required String selectedContextId,
  required String selectedContextName,
}) async {
  final db = getIt<AppDatabase>();
  final contextRepository = getIt<ContextRepository>();

  final now = DateTime.now();

  // 1. Mark pending resolution resolved
  await db.pendingResolutions.markResolved(
    id: pendingResolutionId,
    selectedContextId: selectedContextId,
    source: 'user_confirmed',
    resolvedAt: now.millisecondsSinceEpoch,
  );

  // 2. Link context
  await contextRepository.linkMemory(
    MemoryContextLink(
      memoryId: noteId,
      contextId: selectedContextId,
      role: 'user_confirmed',
      confidence: 1.0,
      createdAt: now,
    ),
  );

  // 3. Update note status to completed
  await db.notes.updateStatus(noteId, 'completed');

  // 4. Invalidate provider
  ref.invalidate(noteUnderstandingProvider(noteId));
  ref.invalidate(noteDetailProvider(noteId));
}
