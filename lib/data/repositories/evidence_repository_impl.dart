import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/entities/memory_evidence.dart';
import '../../domain/repositories/evidence_repository.dart';
import '../local/database/app_database.dart';

class EvidenceRepositoryImpl implements EvidenceRepository {
  EvidenceRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<MemoryEvidence>> watchAll() {
    return _db.evidence.watchAll().map(
          (rows) => rows.map(_rowToEvidence).toList(),
        );
  }

  @override
  Future<MemoryEvidence?> getById(String id) async {
    final row = await _db.evidence.getById(id);
    return row == null ? null : _rowToEvidence(row);
  }

  @override
  Future<List<MemoryEvidence>> getByMemoryId(String memoryId) async {
    final rows = await _db.evidence.getByMemoryId(memoryId);
    return rows.map(_rowToEvidence).toList();
  }

  @override
  Future<List<MemoryEvidence>> getByContextId(String contextId) async {
    final rows = await _db.evidence.getByContextId(contextId);
    return rows.map(_rowToEvidence).toList();
  }

  @override
  Future<void> saveEvidence(MemoryEvidence evidence) {
    final signalsJson = jsonEncode(evidence.signals.map((s) => s.toJson()).toList());

    return _db.evidence.insertEvidence(
      MemoryEvidenceTableCompanion.insert(
        id: evidence.id,
        sourceMemoryId: evidence.sourceMemoryId,
        sourceTextSnippet: Value(evidence.sourceTextSnippet),
        targetContextId: evidence.targetContextId,
        targetContextName: Value(evidence.targetContextName),
        relationType: Value(evidence.relationType),
        confidence: Value(evidence.confidence),
        inferenceType: Value(evidence.inferenceType.name),
        signalsJson: Value(signalsJson),
        explanation: Value(evidence.explanation),
        createdAt: evidence.createdAt.millisecondsSinceEpoch,
      ),
    );
  }

  @override
  Future<void> deleteByMemoryId(String memoryId) {
    return _db.evidence.deleteByMemoryId(memoryId);
  }

  MemoryEvidence _rowToEvidence(MemoryEvidenceTableData row) {
    List<EvidenceSignal> signals = [];
    try {
      final decoded = jsonDecode(row.signalsJson) as List<dynamic>;
      signals = decoded
          .whereType<Map<String, dynamic>>()
          .map((s) => EvidenceSignal.fromJson(s))
          .toList();
    } catch (_) {}

    return MemoryEvidence(
      id: row.id,
      sourceMemoryId: row.sourceMemoryId,
      sourceTextSnippet: row.sourceTextSnippet,
      targetContextId: row.targetContextId,
      targetContextName: row.targetContextName,
      relationType: row.relationType,
      confidence: row.confidence,
      inferenceType: InferenceType.fromString(row.inferenceType),
      signals: signals,
      explanation: row.explanation,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
    );
  }
}
