import 'package:drift/drift.dart';

/// Drift table storing memories awaiting human clarification and context disambiguation.
class PendingResolutionsTable extends Table {
  @override
  String get tableName => 'pending_resolutions';

  TextColumn get id => text()();
  TextColumn get memoryId => text()();
  TextColumn get noteTextSnippet => text().withDefault(const Constant(''))();

  /// JSON-encoded array of ResolutionCandidateOption
  TextColumn get candidatesJson => text().withDefault(const Constant('[]'))();

  /// 'pending', 'resolved', 'dismissed'
  TextColumn get status => text().withDefault(const Constant('pending'))();

  TextColumn get selectedContextId => text().nullable()();

  /// 'automatic', 'user_confirmed', 'user_rejected', 'manual'
  TextColumn get resolutionSource => text().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get resolvedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
