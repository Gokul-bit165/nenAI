import 'package:uuid/uuid.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/entities_dao.dart';
import '../../domain/ai/note_analysis_result.dart';
import '../../domain/entities/memory_operation.dart';

class EntityResolver {
  EntityResolver(this._entitiesDao);

  final EntitiesDao _entitiesDao;
  static const _uuid = Uuid();

  /// Resolves a list of entity mentions against existing database records.
  Future<List<ResolvedEntity>> resolveAll(List<ExtractedEntityMention> mentions) async {
    final resolved = <ResolvedEntity>[];
    for (final mention in mentions) {
      final res = await resolve(mention);
      resolved.add(res);
    }
    return resolved;
  }

  /// Resolves a single entity mention using multi-tier matching.
  Future<ResolvedEntity> resolve(ExtractedEntityMention mention) async {
    final rawName = mention.name.trim();
    if (rawName.isEmpty) {
      final newId = _uuid.v4();
      return ResolvedEntity(
        originalMention: rawName,
        entityId: newId,
        name: rawName,
        type: mention.type,
        status: ResolutionStatus.create,
        confidence: 0.0,
      );
    }

    final canonical = _toCanonical(rawName);

    // Tier 1: Exact Canonical Match
    final exactMatch = await _entitiesDao.getByCanonicalName(canonical);
    if (exactMatch != null) {
      return ResolvedEntity(
        originalMention: rawName,
        entityId: exactMatch.id,
        name: exactMatch.name,
        type: exactMatch.type,
        status: ResolutionStatus.match,
        confidence: 1.0,
        canonicalName: exactMatch.canonicalName,
      );
    }

    // Tier 2: Fuzzy & Alias candidate search
    final allEntities = await _entitiesDao.getAll();
    if (allEntities.isEmpty) {
      final newId = _uuid.v4();
      return ResolvedEntity(
        originalMention: rawName,
        entityId: newId,
        name: rawName,
        type: mention.type,
        status: ResolutionStatus.create,
        confidence: 1.0,
        canonicalName: canonical,
      );
    }

    final candidateMatches = <({EntitiesTableData entity, double score})>[];

    for (final entity in allEntities) {
      final score = _calculateSimilarity(canonical, entity.canonicalName);
      if (score >= EntityResolutionConfig.ambiguousThreshold) {
        candidateMatches.add((entity: entity, score: score));
      }
    }

    // Sort by similarity descending
    candidateMatches.sort((a, b) => b.score.compareTo(a.score));

    if (candidateMatches.isNotEmpty) {
      final top = candidateMatches.first;

      // High confidence match
      if (top.score >= EntityResolutionConfig.autoMatchThreshold) {
        return ResolvedEntity(
          originalMention: rawName,
          entityId: top.entity.id,
          name: top.entity.name,
          type: top.entity.type,
          status: ResolutionStatus.match,
          confidence: top.score,
          canonicalName: top.entity.canonicalName,
        );
      }

      // Multiple ambiguous matches in the range [0.70, 0.89] (e.g. Arun Kumar vs Arun Prakash)
      if (candidateMatches.length > 1 &&
          candidateMatches[1].score >= EntityResolutionConfig.ambiguousThreshold) {
        return ResolvedEntity(
          originalMention: rawName,
          entityId: _uuid.v4(),
          name: rawName,
          type: mention.type,
          status: ResolutionStatus.ambiguous,
          confidence: top.score,
          canonicalName: canonical,
        );
      }

      // Single match with moderate confidence
      if (top.score >= EntityResolutionConfig.ambiguousThreshold) {
        return ResolvedEntity(
          originalMention: rawName,
          entityId: top.entity.id,
          name: top.entity.name,
          type: top.entity.type,
          status: ResolutionStatus.match,
          confidence: top.score,
          canonicalName: top.entity.canonicalName,
        );
      }
    }

    // Novel entity creation
    final newId = _uuid.v4();
    return ResolvedEntity(
      originalMention: rawName,
      entityId: newId,
      name: rawName,
      type: mention.type,
      status: ResolutionStatus.create,
      confidence: 1.0,
      canonicalName: canonical,
    );
  }

  String _toCanonical(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  double _calculateSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    // Check if one contains the other as a full word
    if (s1.contains(s2) || s2.contains(s1)) {
      final minLen = s1.length < s2.length ? s1.length : s2.length;
      final maxLen = s1.length > s2.length ? s1.length : s2.length;
      return minLen / maxLen;
    }

    final distance = _levenshtein(s1, s2);
    final maxLen = s1.length > s2.length ? s1.length : s2.length;
    return 1.0 - (distance / maxLen);
  }

  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    final v0 = List<int>.generate(t.length + 1, (i) => i);
    final v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        final cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].reduce((a, b) => a < b ? a : b);
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[t.length];
  }
}
