import '../../data/local/database/daos/entities_dao.dart';
import '../../data/local/database/daos/relationships_dao.dart';
import '../../domain/ai/note_analysis_result.dart';

/// Evidence bundle for a single entity candidate found in the KG.
class EntityEvidence {
  const EntityEvidence({
    required this.entityId,
    required this.entityName,
    required this.entityType,
    required this.matchConfidence,
    required this.signals,
    this.linkedMemoryIds = const [],
  });

  final String entityId;
  final String entityName;
  final String entityType;

  /// Overall 0.0–1.0 confidence that the note's mention matches this KG entity.
  final double matchConfidence;

  /// Human-readable signal list, e.g. ["exact_name_match", "type_match:project"].
  final List<String> signals;

  /// Memory IDs where this entity has appeared before (via relationships table).
  final List<String> linkedMemoryIds;

  @override
  String toString() =>
      'EntityEvidence(entity: $entityName, conf: ${matchConfidence.toStringAsFixed(2)}, signals: $signals)';
}

/// Computes entity-level evidence bundles BEFORE context candidate scoring.
///
/// Runs deterministically (zero LLM calls). For every entity mention in the
/// incoming note's [NoteAnalysisResult], it searches the existing KG and
/// returns a scored [EntityEvidence] bundle.
///
/// This evidence is then fed into [ContextCandidateRetriever] to boost context
/// candidates that genuinely share known entities with the incoming note.
class RelationshipEvidenceBuilder {
  const RelationshipEvidenceBuilder({
    required EntitiesDao entitiesDao,
    required RelationshipsDao relationshipsDao,
  })  : _entitiesDao = entitiesDao,
        _relationshipsDao = relationshipsDao;

  final EntitiesDao _entitiesDao;
  final RelationshipsDao _relationshipsDao;

  /// Returns scored entity evidence for every mention in [analysis].
  Future<List<EntityEvidence>> buildEvidenceFor(
    NoteAnalysisResult analysis, {
    DateTime? noteTimestamp,
  }) async {
    final allEntities = await _entitiesDao.getAll();
    if (allEntities.isEmpty) return const [];

    final evidences = <EntityEvidence>[];
    final now = noteTimestamp ?? DateTime.now();

    for (final mention in analysis.entities) {
      final mentionLower = mention.name.toLowerCase().trim();
      if (mentionLower.isEmpty || mentionLower.length < 2) continue;

      double bestScore = 0.0;
      String? bestEntityId;
      String? bestEntityName;
      String? bestEntityType;
      final bestSignals = <String>[];
      List<String> bestMemoryIds = [];

      for (final entity in allEntities) {
        final nameLower = entity.name.toLowerCase();
        final canonicalLower = entity.canonicalName.toLowerCase();
        final signals = <String>[];
        double score = 0.0;

        // Signal 1: Exact name match (+0.80)
        if (mentionLower == nameLower || mentionLower == canonicalLower) {
          score += 0.80;
          signals.add('exact_name_match');
        }
        // Signal 2: Substring / contains match (+0.50)
        else if (nameLower.contains(mentionLower) ||
            mentionLower.contains(nameLower)) {
          score += 0.50;
          signals.add('partial_name_match');
        }
        // Signal 3: Canonical match (+0.35)
        else if (canonicalLower.contains(mentionLower) ||
            mentionLower.contains(canonicalLower)) {
          score += 0.35;
          signals.add('canonical_name_match');
        }

        if (score == 0.0) continue;

        // Signal 4: Entity type match (+0.20)
        if (entity.type.toLowerCase() == mention.type.toLowerCase()) {
          score += 0.20;
          signals.add('type_match:${mention.type}');
        }

        // Signal 5: Temporal proximity of entity creation (+0.30 / +0.15)
        final createdAt =
            DateTime.fromMillisecondsSinceEpoch(entity.createdAt);
        final diffHours = now.difference(createdAt).inHours.abs();
        if (diffHours <= 24) {
          score += 0.30;
          signals.add('temporal_proximity_<24h');
        } else if (diffHours <= 72) {
          score += 0.15;
          signals.add('temporal_proximity_<72h');
        }

        // Signal 6: Has existing KG relationships (+0.25)
        final rels = await _relationshipsDao.getByEntityId(entity.id);
        final memoryIds = rels
            .map((r) => r.sourceMemoryId)
            .whereType<String>()
            .where((id) => id.isNotEmpty)
            .toList();
        if (rels.isNotEmpty) {
          score += 0.25;
          signals.add('has_kg_relationships:${rels.length}');
        }

        if (score > bestScore) {
          bestScore = score;
          bestEntityId = entity.id;
          bestEntityName = entity.name;
          bestEntityType = entity.type;
          bestSignals
            ..clear()
            ..addAll(signals);
          bestMemoryIds = memoryIds;
        }
      }

      if (bestEntityId != null && bestScore > 0.30) {
        evidences.add(EntityEvidence(
          entityId: bestEntityId,
          entityName: bestEntityName!,
          entityType: bestEntityType!,
          matchConfidence: bestScore.clamp(0.0, 1.0),
          signals: List.unmodifiable(bestSignals),
          linkedMemoryIds: bestMemoryIds,
        ));
      }
    }

    // Also check explicit relationships in analysis
    for (final rel in analysis.explicitRelationships) {
      for (final name in [rel.source, rel.target]) {
        final nameLower = name.toLowerCase().trim();
        if (nameLower.isEmpty) continue;
        for (final entity in allEntities) {
          if (entity.name.toLowerCase() == nameLower ||
              entity.canonicalName.contains(nameLower)) {
            if (!evidences.any((e) => e.entityId == entity.id)) {
              final rels = await _relationshipsDao.getByEntityId(entity.id);
              final memoryIds = rels
                  .map((r) => r.sourceMemoryId)
                  .whereType<String>()
                  .where((id) => id.isNotEmpty)
                  .toList();
              evidences.add(EntityEvidence(
                entityId: entity.id,
                entityName: entity.name,
                entityType: entity.type,
                matchConfidence: (rel.confidence * 0.70).clamp(0.0, 1.0),
                signals: ['explicit_relationship:${rel.relation}'],
                linkedMemoryIds: memoryIds,
              ));
            }
          }
        }
      }
    }

    // Sort by confidence descending
    evidences.sort((a, b) => b.matchConfidence.compareTo(a.matchConfidence));
    return evidences;
  }
}
