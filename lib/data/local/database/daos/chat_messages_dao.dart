import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/chat_messages_table.dart';

part 'chat_messages_dao.g.dart';

@DriftAccessor(tables: [ChatMessagesTable])
class ChatMessagesDao extends DatabaseAccessor<AppDatabase> with _$ChatMessagesDaoMixin {
  ChatMessagesDao(super.db);

  Stream<List<ChatMessagesTableData>> watchAllMessages() =>
      (select(chatMessagesTable)..orderBy([(t) => OrderingTerm.asc(t.timestamp)])).watch();

  Future<List<ChatMessagesTableData>> getAllMessages() =>
      (select(chatMessagesTable)..orderBy([(t) => OrderingTerm.asc(t.timestamp)])).get();

  Future<void> insertMessage(ChatMessagesTableCompanion companion) =>
      into(chatMessagesTable).insertOnConflictUpdate(companion);

  Future<void> updateMessage(ChatMessagesTableCompanion companion) =>
      (update(chatMessagesTable)..where((t) => t.id.equals(companion.id.value))).write(companion);

  Future<void> clearAll() => delete(chatMessagesTable).go();
}
