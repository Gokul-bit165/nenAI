import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/entities_dao.dart';

/// Structured retrieval plan produced before searching.
class RetrievalPlan {
  const RetrievalPlan({
    required this.query,
    required this.targetEntities,
    required this.searchKeywords,
    this.intent = 'retrieve_fact',
  });

  final String query;
  final List<EntitiesTableData> targetEntities;
  final List<String> searchKeywords;
  final String intent;
}

/// Analyzes query to identify target entities and plan multi-modal retrieval.
class RetrievalPlanner {
  RetrievalPlanner(this._entitiesDao);

  final EntitiesDao _entitiesDao;

  Future<RetrievalPlan> plan(String query) async {
    final clean = query.trim();
    final lower = clean.toLowerCase();

    // 1. Search if any stored entities are mentioned in the query
    final allEntities = await _entitiesDao.getAll();
    final matchedEntities = <EntitiesTableData>[];

    for (final entity in allEntities) {
      final nameLower = entity.name.toLowerCase();
      final canonicalLower = entity.canonicalName;
      if (lower.contains(nameLower) || lower.contains(canonicalLower)) {
        matchedEntities.add(entity);
      }
    }

    // 2. Identify Intent
    String intent = 'retrieve_fact';
    if (lower.contains('task') || lower.contains('todo') || lower.contains('need to do')) {
      intent = 'retrieve_tasks';
    } else if (lower.contains('who') || lower.contains('person') || lower.contains('people')) {
      intent = 'retrieve_person';
    } else if (lower.contains('project') || lower.contains('architecture')) {
      intent = 'retrieve_project';
    }

    // 3. Extract keywords
    const stopWords = {
      'what', 'did', 'do', 'does', 'how', 'why', 'when', 'where', 'who', 'which',
      'i', 'me', 'my', 'you', 'your', 'we', 'our', 'is', 'are', 'was', 'were', 'be',
      'been', 'being', 'have', 'has', 'had', 'the', 'a', 'an', 'and', 'or', 'but',
      'in', 'on', 'at', 'to', 'for', 'with', 'about', 'against', 'between', 'into',
      'tell', 'show', 'find', 'remember', 'recall', 'suggest', 'recommend'
    };

    final rawTokens = lower.split(RegExp(r'[\s_,\.\?\!]+'));
    final keywords = rawTokens.where((w) => w.length > 2 && !stopWords.contains(w)).toList();

    return RetrievalPlan(
      query: clean,
      targetEntities: matchedEntities,
      searchKeywords: keywords,
      intent: intent,
    );
  }
}
