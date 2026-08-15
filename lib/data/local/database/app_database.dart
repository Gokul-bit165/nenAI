import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../../core/constants/app_constants.dart';
import 'tables/notes_table.dart';
import 'tables/embeddings_table.dart';
import 'tables/clusters_table.dart';
import 'tables/chat_messages_table.dart';
import 'tables/entities_table.dart';
import 'tables/relationships_table.dart';
import 'tables/tasks_table.dart';
import 'tables/memory_entities_table.dart';
import 'tables/context_nodes_table.dart';
import 'tables/context_edges_table.dart';
import 'tables/memory_contexts_table.dart';
import 'tables/memory_evidence_table.dart';
import 'tables/pending_resolutions_table.dart';

import 'daos/notes_dao.dart';
import 'daos/embeddings_dao.dart';
import 'daos/clusters_dao.dart';
import 'daos/chat_messages_dao.dart';
import 'daos/entities_dao.dart';
import 'daos/relationships_dao.dart';
import 'daos/tasks_dao.dart';
import 'daos/context_dao.dart';
import 'daos/evidence_dao.dart';
import 'daos/pending_resolutions_dao.dart';

part 'app_database.g.dart';

/// The single Drift database instance for NENAI.
@DriftDatabase(
  tables: [
    NotesTable,
    EmbeddingsTable,
    ClustersTable,
    ChatMessagesTable,
    EntitiesTable,
    RelationshipsTable,
    TasksTable,
    MemoryEntitiesTable,
    ContextNodesTable,
    ContextEdgesTable,
    MemoryContextsTable,
    MemoryEvidenceTable,
    PendingResolutionsTable,
  ],
  daos: [
    NotesDao,
    EmbeddingsDao,
    ClustersDao,
    ChatMessagesDao,
    EntitiesDao,
    RelationshipsDao,
    TasksDao,
    ContextDao,
    EvidenceDao,
    PendingResolutionsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => AppConstants.dbVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(chatMessagesTable);
          }
          if (from < 3) {
            await m.createTable(entitiesTable);
            await m.createTable(relationshipsTable);
            await m.createTable(tasksTable);
            await m.createTable(memoryEntitiesTable);
          }
          if (from < 4) {
            await m.createTable(contextNodesTable);
            await m.createTable(contextEdgesTable);
            await m.createTable(memoryContextsTable);
          }
          if (from < 5) {
            await m.createTable(memoryEvidenceTable);
          }
          if (from < 6) {
            await m.createTable(pendingResolutionsTable);
          }
          if (from < 7) {
            // Add inferenceType to existing relationships (defaults to 'extracted')
            await m.addColumn(
              relationshipsTable,
              relationshipsTable.inferenceType as GeneratedColumn<Object>,
            );
          }
        },
      );

  // ── DAO accessors ──────────────────────────────────────────────────────────
  NotesDao get notes => notesDao;
  EmbeddingsDao get embeddings => embeddingsDao;
  ClustersDao get clusters => clustersDao;
  ChatMessagesDao get chatMessages => chatMessagesDao;
  EntitiesDao get entities => entitiesDao;
  RelationshipsDao get relationships => relationshipsDao;
  TasksDao get tasks => tasksDao;
  ContextDao get contexts => contextDao;
  EvidenceDao get evidence => evidenceDao;
  PendingResolutionsDao get pendingResolutions => pendingResolutionsDao;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: AppConstants.dbName);
}
