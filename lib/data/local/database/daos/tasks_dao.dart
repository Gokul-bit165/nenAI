import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tasks_table.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [TasksTable])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  Stream<List<TasksTableData>> watchAll() =>
      (select(tasksTable)..orderBy([(t) => OrderingTerm.asc(t.isCompleted), (t) => OrderingTerm.asc(t.dueTimestamp)]))
          .watch();

  Future<List<TasksTableData>> getAll() => select(tasksTable).get();

  Future<List<TasksTableData>> getByMemoryId(String memoryId) =>
      (select(tasksTable)..where((t) => t.memoryId.equals(memoryId))).get();

  Future<List<TasksTableData>> getPendingTasks() =>
      (select(tasksTable)..where((t) => t.isCompleted.equals(false))).get();

  Future<void> insertTask(TasksTableCompanion task) =>
      into(tasksTable).insertOnConflictUpdate(task);

  Future<void> toggleTaskCompletion(String id, bool isCompleted) =>
      (update(tasksTable)..where((t) => t.id.equals(id))).write(
        TasksTableCompanion(
          isCompleted: Value(isCompleted),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  Future<void> deleteTask(String id) =>
      (delete(tasksTable)..where((t) => t.id.equals(id))).go();
}
