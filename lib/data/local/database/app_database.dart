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

import 'daos/notes_dao.dart';
import 'daos/embeddings_dao.dart';
import 'daos/clusters_dao.dart';
import 'daos/chat_messages_dao.dart';
import 'daos/entities_dao.dart';
import 'daos/relationships_dao.dart';
import 'daos/tasks_dao.dart';

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
  ],
  daos: [
    NotesDao,
    EmbeddingsDao,
    ClustersDao,
    ChatMessagesDao,
    EntitiesDao,
    RelationshipsDao,
    TasksDao,
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
}

QueryExecutor _openConnection() {
  return driftDatabase(name: AppConstants.dbName);
}
