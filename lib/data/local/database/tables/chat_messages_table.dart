import 'package:drift/drift.dart';

/// Table for persisting chat messages permanently across app sessions.
class ChatMessagesTable extends Table {
  TextColumn get id => text()();
  TextColumn get textContent => text()();
  BoolColumn get isUser => boolean()();
  IntColumn get timestamp => integer()();
  TextColumn get citedNotesJson => text().withDefault(const Constant('[]'))();
  TextColumn get pendingActionJson => text().nullable()();
  TextColumn get actionExecutedMessage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
