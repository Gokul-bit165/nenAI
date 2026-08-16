import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/entities_dao.dart';
import '../../data/local/database/daos/relationships_dao.dart';

/// Structured result returned by [KGQueryEngine] when the Knowledge Graph contains
/// an answer for the user's recall question.
class KGQueryResult {
  const KGQueryResult({
    required this.answer,
    required this.triples,
    required this.sourceNoteIds,
    this.used2Hop = false,
  });

  /// Natural-language structured answer assembled from graph facts.
  final String answer;

  /// Raw triple strings, e.g. "Dean --suggested--> Gemma --for--> NENAI".
  final List<String> triples;

  /// Memory note IDs from which the graph relationships originated (for citations).
  final List<String> sourceNoteIds;

  /// Whether a 2-hop graph path was traversed to construct this answer.
  final bool used2Hop;
}

/// KG-First Query Engine: Queries the SQLite Knowledge Graph (entities + relationships)
/// directly before falling back to note-text vector/keyword search.
///
/// Multi-hop capabilities:
///   - 1-hop: "What technology does NENAI use?" → NENAI --uses--> Flutter
///   - 2-hop: "Who suggested Flutter for NENAI?" → Dean --suggested--> Flutter --for--> NENAI
class KGQueryEngine {
  KGQueryEngine({
    required AppDatabase db,
    EntitiesDao? entitiesDao,
    RelationshipsDao? relationshipsDao,
  })  : _entitiesDao = entitiesDao ?? db.entities,
        _relationshipsDao = relationshipsDao ?? db.relationships;

  final EntitiesDao _entitiesDao;
  final RelationshipsDao _relationshipsDao;

  /// Queries the Knowledge Graph for facts relevant to [question].
  /// Returns null if the graph does not contain enough information to answer.
  Future<KGQueryResult?> query(
    String question, {
    List<String> recentContext = const [],
  }) async {
    final lowerQ = question.toLowerCase().trim();
    if (lowerQ.isEmpty) return null;

    // 1. Fetch all entities stored in the DB
    final allEntities = await _entitiesDao.getAll();
    if (allEntities.isEmpty) return null;

    // 2. Find entity mentions in the question
    final matchedEntities = <EntitiesTableData>[];
    for (final entity in allEntities) {
      final nameLower = entity.name.toLowerCase();
      final canonicalLower = entity.canonicalName.toLowerCase();
      if (nameLower.length >= 3 && lowerQ.contains(nameLower)) {
        matchedEntities.add(entity);
      } else if (canonicalLower.length >= 3 && lowerQ.contains(canonicalLower)) {
        if (!matchedEntities.any((e) => e.id == entity.id)) {
          matchedEntities.add(entity);
        }
      }
    }

    if (matchedEntities.isEmpty) return null;

    // 3. Try 2-hop traversal if 2+ entities were matched in the question
    if (matchedEntities.length >= 2) {
      final e1 = matchedEntities[0];
      final e2 = matchedEntities[1];

      final paths = await _relationshipsDao.getTwoHopPaths(e1.id, e2.id);
      if (paths.isNotEmpty) {
        final tripleStrings = <String>[];
        final memoryIds = <String>{};
        final answerLines = <String>[];

        for (final p in paths) {
          final t1 = '${p.source.name} --${p.hop1.relation}--> ${p.intermediate.name}';
          final t2 = '${p.intermediate.name} --${p.hop2.relation}--> ${p.target.name}';
          tripleStrings.add('$t1, $t2');

          if (p.hop1.sourceMemoryId.isNotEmpty) memoryIds.add(p.hop1.sourceMemoryId);
          if (p.hop2.sourceMemoryId.isNotEmpty) memoryIds.add(p.hop2.sourceMemoryId);

          answerLines.add(
            '${p.source.name} ${p.hop1.relation} ${p.intermediate.name}, which is ${p.hop2.relation} ${p.target.name}.',
          );
        }

        return KGQueryResult(
          answer: answerLines.join('\n'),
          triples: tripleStrings,
          sourceNoteIds: memoryIds.toList(),
          used2Hop: true,
        );
      }
    }

    // 4. 1-hop traversal for each matched entity
    final tripleStrings = <String>[];
    final memoryIds = <String>{};
    final answerLines = <String>[];

    for (final entity in matchedEntities) {
      final neighborhood = await _relationshipsDao.getNeighborhood(entity.id);
      for (final item in neighborhood) {
        final rel = item.relationship;
        final src = item.source;
        final tgt = item.target;

        final tStr = '${src.name} --${rel.relation}--> ${tgt.name}';
        if (!tripleStrings.contains(tStr)) {
          tripleStrings.add(tStr);
          if (rel.sourceMemoryId.isNotEmpty) memoryIds.add(rel.sourceMemoryId);
          answerLines.add('${src.name} ${rel.relation} ${tgt.name}');
        }
      }
    }

    if (answerLines.isEmpty) return null;

    final formattedAnswer = matchedEntities.length == 1
        ? 'Based on your memory graph for ${matchedEntities.first.name}:\n• ${answerLines.join('\n• ')}'
        : 'Based on your memory graph:\n• ${answerLines.join('\n• ')}';

    return KGQueryResult(
      answer: formattedAnswer,
      triples: tripleStrings,
      sourceNoteIds: memoryIds.toList(),
      used2Hop: false,
    );
  }
}
