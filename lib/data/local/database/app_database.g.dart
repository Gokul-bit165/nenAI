// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NotesTableTable extends NotesTable
    with TableInfo<$NotesTableTable, NotesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _keywordsJsonMeta =
      const VerificationMeta('keywordsJson');
  @override
  late final GeneratedColumn<String> keywordsJson = GeneratedColumn<String>(
      'keywords_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _clusterIdMeta =
      const VerificationMeta('clusterId');
  @override
  late final GeneratedColumn<String> clusterId = GeneratedColumn<String>(
      'cluster_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _relatedNoteIdsJsonMeta =
      const VerificationMeta('relatedNoteIdsJson');
  @override
  late final GeneratedColumn<String> relatedNoteIdsJson =
      GeneratedColumn<String>('related_note_ids_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _processingStatusMeta =
      const VerificationMeta('processingStatus');
  @override
  late final GeneratedColumn<String> processingStatus = GeneratedColumn<String>(
      'processing_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        content,
        summary,
        keywordsJson,
        clusterId,
        relatedNoteIdsJson,
        processingStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<NotesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('keywords_json')) {
      context.handle(
          _keywordsJsonMeta,
          keywordsJson.isAcceptableOrUnknown(
              data['keywords_json']!, _keywordsJsonMeta));
    }
    if (data.containsKey('cluster_id')) {
      context.handle(_clusterIdMeta,
          clusterId.isAcceptableOrUnknown(data['cluster_id']!, _clusterIdMeta));
    }
    if (data.containsKey('related_note_ids_json')) {
      context.handle(
          _relatedNoteIdsJsonMeta,
          relatedNoteIdsJson.isAcceptableOrUnknown(
              data['related_note_ids_json']!, _relatedNoteIdsJsonMeta));
    }
    if (data.containsKey('processing_status')) {
      context.handle(
          _processingStatusMeta,
          processingStatus.isAcceptableOrUnknown(
              data['processing_status']!, _processingStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      keywordsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keywords_json'])!,
      clusterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cluster_id']),
      relatedNoteIdsJson: attachedDatabase.typeMapping.read(DriftSqlType.string,
          data['${effectivePrefix}related_note_ids_json'])!,
      processingStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}processing_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NotesTableTable createAlias(String alias) {
    return $NotesTableTable(attachedDatabase, alias);
  }
}

class NotesTableData extends DataClass implements Insertable<NotesTableData> {
  final String id;
  final String content;

  /// AI-generated 1–2 sentence summary. Null until processing completes.
  final String? summary;

  /// JSON-encoded list of keyword strings. Empty array '[]' by default.
  final String keywordsJson;

  /// Foreign key to clusters table. Null until cluster is assigned.
  final String? clusterId;

  /// JSON-encoded list of related note IDs.
  final String relatedNoteIdsJson;

  /// One of: pending | processing | completed | failed
  final String processingStatus;
  final int createdAt;
  final int updatedAt;
  const NotesTableData(
      {required this.id,
      required this.content,
      this.summary,
      required this.keywordsJson,
      this.clusterId,
      required this.relatedNoteIdsJson,
      required this.processingStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['keywords_json'] = Variable<String>(keywordsJson);
    if (!nullToAbsent || clusterId != null) {
      map['cluster_id'] = Variable<String>(clusterId);
    }
    map['related_note_ids_json'] = Variable<String>(relatedNoteIdsJson);
    map['processing_status'] = Variable<String>(processingStatus);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  NotesTableCompanion toCompanion(bool nullToAbsent) {
    return NotesTableCompanion(
      id: Value(id),
      content: Value(content),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      keywordsJson: Value(keywordsJson),
      clusterId: clusterId == null && nullToAbsent
          ? const Value.absent()
          : Value(clusterId),
      relatedNoteIdsJson: Value(relatedNoteIdsJson),
      processingStatus: Value(processingStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotesTableData(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      summary: serializer.fromJson<String?>(json['summary']),
      keywordsJson: serializer.fromJson<String>(json['keywordsJson']),
      clusterId: serializer.fromJson<String?>(json['clusterId']),
      relatedNoteIdsJson:
          serializer.fromJson<String>(json['relatedNoteIdsJson']),
      processingStatus: serializer.fromJson<String>(json['processingStatus']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'summary': serializer.toJson<String?>(summary),
      'keywordsJson': serializer.toJson<String>(keywordsJson),
      'clusterId': serializer.toJson<String?>(clusterId),
      'relatedNoteIdsJson': serializer.toJson<String>(relatedNoteIdsJson),
      'processingStatus': serializer.toJson<String>(processingStatus),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  NotesTableData copyWith(
          {String? id,
          String? content,
          Value<String?> summary = const Value.absent(),
          String? keywordsJson,
          Value<String?> clusterId = const Value.absent(),
          String? relatedNoteIdsJson,
          String? processingStatus,
          int? createdAt,
          int? updatedAt}) =>
      NotesTableData(
        id: id ?? this.id,
        content: content ?? this.content,
        summary: summary.present ? summary.value : this.summary,
        keywordsJson: keywordsJson ?? this.keywordsJson,
        clusterId: clusterId.present ? clusterId.value : this.clusterId,
        relatedNoteIdsJson: relatedNoteIdsJson ?? this.relatedNoteIdsJson,
        processingStatus: processingStatus ?? this.processingStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NotesTableData copyWithCompanion(NotesTableCompanion data) {
    return NotesTableData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      summary: data.summary.present ? data.summary.value : this.summary,
      keywordsJson: data.keywordsJson.present
          ? data.keywordsJson.value
          : this.keywordsJson,
      clusterId: data.clusterId.present ? data.clusterId.value : this.clusterId,
      relatedNoteIdsJson: data.relatedNoteIdsJson.present
          ? data.relatedNoteIdsJson.value
          : this.relatedNoteIdsJson,
      processingStatus: data.processingStatus.present
          ? data.processingStatus.value
          : this.processingStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('summary: $summary, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('clusterId: $clusterId, ')
          ..write('relatedNoteIdsJson: $relatedNoteIdsJson, ')
          ..write('processingStatus: $processingStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, summary, keywordsJson, clusterId,
      relatedNoteIdsJson, processingStatus, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotesTableData &&
          other.id == this.id &&
          other.content == this.content &&
          other.summary == this.summary &&
          other.keywordsJson == this.keywordsJson &&
          other.clusterId == this.clusterId &&
          other.relatedNoteIdsJson == this.relatedNoteIdsJson &&
          other.processingStatus == this.processingStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesTableCompanion extends UpdateCompanion<NotesTableData> {
  final Value<String> id;
  final Value<String> content;
  final Value<String?> summary;
  final Value<String> keywordsJson;
  final Value<String?> clusterId;
  final Value<String> relatedNoteIdsJson;
  final Value<String> processingStatus;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const NotesTableCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.summary = const Value.absent(),
    this.keywordsJson = const Value.absent(),
    this.clusterId = const Value.absent(),
    this.relatedNoteIdsJson = const Value.absent(),
    this.processingStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesTableCompanion.insert({
    required String id,
    required String content,
    this.summary = const Value.absent(),
    this.keywordsJson = const Value.absent(),
    this.clusterId = const Value.absent(),
    this.relatedNoteIdsJson = const Value.absent(),
    this.processingStatus = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        content = Value(content),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NotesTableData> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<String>? summary,
    Expression<String>? keywordsJson,
    Expression<String>? clusterId,
    Expression<String>? relatedNoteIdsJson,
    Expression<String>? processingStatus,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (summary != null) 'summary': summary,
      if (keywordsJson != null) 'keywords_json': keywordsJson,
      if (clusterId != null) 'cluster_id': clusterId,
      if (relatedNoteIdsJson != null)
        'related_note_ids_json': relatedNoteIdsJson,
      if (processingStatus != null) 'processing_status': processingStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? content,
      Value<String?>? summary,
      Value<String>? keywordsJson,
      Value<String?>? clusterId,
      Value<String>? relatedNoteIdsJson,
      Value<String>? processingStatus,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return NotesTableCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      keywordsJson: keywordsJson ?? this.keywordsJson,
      clusterId: clusterId ?? this.clusterId,
      relatedNoteIdsJson: relatedNoteIdsJson ?? this.relatedNoteIdsJson,
      processingStatus: processingStatus ?? this.processingStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (keywordsJson.present) {
      map['keywords_json'] = Variable<String>(keywordsJson.value);
    }
    if (clusterId.present) {
      map['cluster_id'] = Variable<String>(clusterId.value);
    }
    if (relatedNoteIdsJson.present) {
      map['related_note_ids_json'] = Variable<String>(relatedNoteIdsJson.value);
    }
    if (processingStatus.present) {
      map['processing_status'] = Variable<String>(processingStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('summary: $summary, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('clusterId: $clusterId, ')
          ..write('relatedNoteIdsJson: $relatedNoteIdsJson, ')
          ..write('processingStatus: $processingStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmbeddingsTableTable extends EmbeddingsTable
    with TableInfo<$EmbeddingsTableTable, EmbeddingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmbeddingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
      'note_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES notes (id) ON DELETE CASCADE'));
  static const VerificationMeta _vectorMeta = const VerificationMeta('vector');
  @override
  late final GeneratedColumn<Uint8List> vector = GeneratedColumn<Uint8List>(
      'vector', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [noteId, vector];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'embeddings';
  @override
  VerificationContext validateIntegrity(
      Insertable<EmbeddingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('vector')) {
      context.handle(_vectorMeta,
          vector.isAcceptableOrUnknown(data['vector']!, _vectorMeta));
    } else if (isInserting) {
      context.missing(_vectorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId};
  @override
  EmbeddingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmbeddingsTableData(
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_id'])!,
      vector: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}vector'])!,
    );
  }

  @override
  $EmbeddingsTableTable createAlias(String alias) {
    return $EmbeddingsTableTable(attachedDatabase, alias);
  }
}

class EmbeddingsTableData extends DataClass
    implements Insertable<EmbeddingsTableData> {
  /// FK → notes.id
  final String noteId;

  /// Raw IEEE 754 little-endian floats: 384 × 4 bytes = 1536 bytes.
  final Uint8List vector;
  const EmbeddingsTableData({required this.noteId, required this.vector});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['vector'] = Variable<Uint8List>(vector);
    return map;
  }

  EmbeddingsTableCompanion toCompanion(bool nullToAbsent) {
    return EmbeddingsTableCompanion(
      noteId: Value(noteId),
      vector: Value(vector),
    );
  }

  factory EmbeddingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmbeddingsTableData(
      noteId: serializer.fromJson<String>(json['noteId']),
      vector: serializer.fromJson<Uint8List>(json['vector']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'vector': serializer.toJson<Uint8List>(vector),
    };
  }

  EmbeddingsTableData copyWith({String? noteId, Uint8List? vector}) =>
      EmbeddingsTableData(
        noteId: noteId ?? this.noteId,
        vector: vector ?? this.vector,
      );
  EmbeddingsTableData copyWithCompanion(EmbeddingsTableCompanion data) {
    return EmbeddingsTableData(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      vector: data.vector.present ? data.vector.value : this.vector,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmbeddingsTableData(')
          ..write('noteId: $noteId, ')
          ..write('vector: $vector')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, $driftBlobEquality.hash(vector));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmbeddingsTableData &&
          other.noteId == this.noteId &&
          $driftBlobEquality.equals(other.vector, this.vector));
}

class EmbeddingsTableCompanion extends UpdateCompanion<EmbeddingsTableData> {
  final Value<String> noteId;
  final Value<Uint8List> vector;
  final Value<int> rowid;
  const EmbeddingsTableCompanion({
    this.noteId = const Value.absent(),
    this.vector = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmbeddingsTableCompanion.insert({
    required String noteId,
    required Uint8List vector,
    this.rowid = const Value.absent(),
  })  : noteId = Value(noteId),
        vector = Value(vector);
  static Insertable<EmbeddingsTableData> custom({
    Expression<String>? noteId,
    Expression<Uint8List>? vector,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (vector != null) 'vector': vector,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmbeddingsTableCompanion copyWith(
      {Value<String>? noteId, Value<Uint8List>? vector, Value<int>? rowid}) {
    return EmbeddingsTableCompanion(
      noteId: noteId ?? this.noteId,
      vector: vector ?? this.vector,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (vector.present) {
      map['vector'] = Variable<Uint8List>(vector.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmbeddingsTableCompanion(')
          ..write('noteId: $noteId, ')
          ..write('vector: $vector, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClustersTableTable extends ClustersTable
    with TableInfo<$ClustersTableTable, ClustersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClustersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, colorHex, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clusters';
  @override
  VerificationContext validateIntegrity(Insertable<ClustersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClustersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClustersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ClustersTableTable createAlias(String alias) {
    return $ClustersTableTable(attachedDatabase, alias);
  }
}

class ClustersTableData extends DataClass
    implements Insertable<ClustersTableData> {
  final String id;

  /// Human-readable name — auto-generated by LLM, editable by user.
  final String name;

  /// Hex colour string e.g. '#7C4DFF'.
  final String colorHex;
  final int createdAt;
  const ClustersTableData(
      {required this.id,
      required this.name,
      required this.colorHex,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ClustersTableCompanion toCompanion(bool nullToAbsent) {
    return ClustersTableCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: Value(colorHex),
      createdAt: Value(createdAt),
    );
  }

  factory ClustersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClustersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ClustersTableData copyWith(
          {String? id, String? name, String? colorHex, int? createdAt}) =>
      ClustersTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        colorHex: colorHex ?? this.colorHex,
        createdAt: createdAt ?? this.createdAt,
      );
  ClustersTableData copyWithCompanion(ClustersTableCompanion data) {
    return ClustersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClustersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHex, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClustersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.createdAt == this.createdAt);
}

class ClustersTableCompanion extends UpdateCompanion<ClustersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> colorHex;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ClustersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClustersTableCompanion.insert({
    required String id,
    required String name,
    required String colorHex,
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        colorHex = Value(colorHex),
        createdAt = Value(createdAt);
  static Insertable<ClustersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClustersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? colorHex,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return ClustersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClustersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTableTable extends ChatMessagesTable
    with TableInfo<$ChatMessagesTableTable, ChatMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'text_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isUserMeta = const VerificationMeta('isUser');
  @override
  late final GeneratedColumn<bool> isUser = GeneratedColumn<bool>(
      'is_user', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_user" IN (0, 1))'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _citedNotesJsonMeta =
      const VerificationMeta('citedNotesJson');
  @override
  late final GeneratedColumn<String> citedNotesJson = GeneratedColumn<String>(
      'cited_notes_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _pendingActionJsonMeta =
      const VerificationMeta('pendingActionJson');
  @override
  late final GeneratedColumn<String> pendingActionJson =
      GeneratedColumn<String>('pending_action_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actionExecutedMessageMeta =
      const VerificationMeta('actionExecutedMessage');
  @override
  late final GeneratedColumn<String> actionExecutedMessage =
      GeneratedColumn<String>('action_executed_message', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        textContent,
        isUser,
        timestamp,
        citedNotesJson,
        pendingActionJson,
        actionExecutedMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChatMessagesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
          _textContentMeta,
          textContent.isAcceptableOrUnknown(
              data['text_content']!, _textContentMeta));
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('is_user')) {
      context.handle(_isUserMeta,
          isUser.isAcceptableOrUnknown(data['is_user']!, _isUserMeta));
    } else if (isInserting) {
      context.missing(_isUserMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('cited_notes_json')) {
      context.handle(
          _citedNotesJsonMeta,
          citedNotesJson.isAcceptableOrUnknown(
              data['cited_notes_json']!, _citedNotesJsonMeta));
    }
    if (data.containsKey('pending_action_json')) {
      context.handle(
          _pendingActionJsonMeta,
          pendingActionJson.isAcceptableOrUnknown(
              data['pending_action_json']!, _pendingActionJsonMeta));
    }
    if (data.containsKey('action_executed_message')) {
      context.handle(
          _actionExecutedMessageMeta,
          actionExecutedMessage.isAcceptableOrUnknown(
              data['action_executed_message']!, _actionExecutedMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessagesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_content'])!,
      isUser: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_user'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      citedNotesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cited_notes_json'])!,
      pendingActionJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pending_action_json']),
      actionExecutedMessage: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}action_executed_message']),
    );
  }

  @override
  $ChatMessagesTableTable createAlias(String alias) {
    return $ChatMessagesTableTable(attachedDatabase, alias);
  }
}

class ChatMessagesTableData extends DataClass
    implements Insertable<ChatMessagesTableData> {
  final String id;
  final String textContent;
  final bool isUser;
  final int timestamp;
  final String citedNotesJson;
  final String? pendingActionJson;
  final String? actionExecutedMessage;
  const ChatMessagesTableData(
      {required this.id,
      required this.textContent,
      required this.isUser,
      required this.timestamp,
      required this.citedNotesJson,
      this.pendingActionJson,
      this.actionExecutedMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['text_content'] = Variable<String>(textContent);
    map['is_user'] = Variable<bool>(isUser);
    map['timestamp'] = Variable<int>(timestamp);
    map['cited_notes_json'] = Variable<String>(citedNotesJson);
    if (!nullToAbsent || pendingActionJson != null) {
      map['pending_action_json'] = Variable<String>(pendingActionJson);
    }
    if (!nullToAbsent || actionExecutedMessage != null) {
      map['action_executed_message'] = Variable<String>(actionExecutedMessage);
    }
    return map;
  }

  ChatMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesTableCompanion(
      id: Value(id),
      textContent: Value(textContent),
      isUser: Value(isUser),
      timestamp: Value(timestamp),
      citedNotesJson: Value(citedNotesJson),
      pendingActionJson: pendingActionJson == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingActionJson),
      actionExecutedMessage: actionExecutedMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(actionExecutedMessage),
    );
  }

  factory ChatMessagesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessagesTableData(
      id: serializer.fromJson<String>(json['id']),
      textContent: serializer.fromJson<String>(json['textContent']),
      isUser: serializer.fromJson<bool>(json['isUser']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      citedNotesJson: serializer.fromJson<String>(json['citedNotesJson']),
      pendingActionJson:
          serializer.fromJson<String?>(json['pendingActionJson']),
      actionExecutedMessage:
          serializer.fromJson<String?>(json['actionExecutedMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'textContent': serializer.toJson<String>(textContent),
      'isUser': serializer.toJson<bool>(isUser),
      'timestamp': serializer.toJson<int>(timestamp),
      'citedNotesJson': serializer.toJson<String>(citedNotesJson),
      'pendingActionJson': serializer.toJson<String?>(pendingActionJson),
      'actionExecutedMessage':
          serializer.toJson<String?>(actionExecutedMessage),
    };
  }

  ChatMessagesTableData copyWith(
          {String? id,
          String? textContent,
          bool? isUser,
          int? timestamp,
          String? citedNotesJson,
          Value<String?> pendingActionJson = const Value.absent(),
          Value<String?> actionExecutedMessage = const Value.absent()}) =>
      ChatMessagesTableData(
        id: id ?? this.id,
        textContent: textContent ?? this.textContent,
        isUser: isUser ?? this.isUser,
        timestamp: timestamp ?? this.timestamp,
        citedNotesJson: citedNotesJson ?? this.citedNotesJson,
        pendingActionJson: pendingActionJson.present
            ? pendingActionJson.value
            : this.pendingActionJson,
        actionExecutedMessage: actionExecutedMessage.present
            ? actionExecutedMessage.value
            : this.actionExecutedMessage,
      );
  ChatMessagesTableData copyWithCompanion(ChatMessagesTableCompanion data) {
    return ChatMessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
      isUser: data.isUser.present ? data.isUser.value : this.isUser,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      citedNotesJson: data.citedNotesJson.present
          ? data.citedNotesJson.value
          : this.citedNotesJson,
      pendingActionJson: data.pendingActionJson.present
          ? data.pendingActionJson.value
          : this.pendingActionJson,
      actionExecutedMessage: data.actionExecutedMessage.present
          ? data.actionExecutedMessage.value
          : this.actionExecutedMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesTableData(')
          ..write('id: $id, ')
          ..write('textContent: $textContent, ')
          ..write('isUser: $isUser, ')
          ..write('timestamp: $timestamp, ')
          ..write('citedNotesJson: $citedNotesJson, ')
          ..write('pendingActionJson: $pendingActionJson, ')
          ..write('actionExecutedMessage: $actionExecutedMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, textContent, isUser, timestamp,
      citedNotesJson, pendingActionJson, actionExecutedMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessagesTableData &&
          other.id == this.id &&
          other.textContent == this.textContent &&
          other.isUser == this.isUser &&
          other.timestamp == this.timestamp &&
          other.citedNotesJson == this.citedNotesJson &&
          other.pendingActionJson == this.pendingActionJson &&
          other.actionExecutedMessage == this.actionExecutedMessage);
}

class ChatMessagesTableCompanion
    extends UpdateCompanion<ChatMessagesTableData> {
  final Value<String> id;
  final Value<String> textContent;
  final Value<bool> isUser;
  final Value<int> timestamp;
  final Value<String> citedNotesJson;
  final Value<String?> pendingActionJson;
  final Value<String?> actionExecutedMessage;
  final Value<int> rowid;
  const ChatMessagesTableCompanion({
    this.id = const Value.absent(),
    this.textContent = const Value.absent(),
    this.isUser = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.citedNotesJson = const Value.absent(),
    this.pendingActionJson = const Value.absent(),
    this.actionExecutedMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesTableCompanion.insert({
    required String id,
    required String textContent,
    required bool isUser,
    required int timestamp,
    this.citedNotesJson = const Value.absent(),
    this.pendingActionJson = const Value.absent(),
    this.actionExecutedMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        textContent = Value(textContent),
        isUser = Value(isUser),
        timestamp = Value(timestamp);
  static Insertable<ChatMessagesTableData> custom({
    Expression<String>? id,
    Expression<String>? textContent,
    Expression<bool>? isUser,
    Expression<int>? timestamp,
    Expression<String>? citedNotesJson,
    Expression<String>? pendingActionJson,
    Expression<String>? actionExecutedMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textContent != null) 'text_content': textContent,
      if (isUser != null) 'is_user': isUser,
      if (timestamp != null) 'timestamp': timestamp,
      if (citedNotesJson != null) 'cited_notes_json': citedNotesJson,
      if (pendingActionJson != null) 'pending_action_json': pendingActionJson,
      if (actionExecutedMessage != null)
        'action_executed_message': actionExecutedMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? textContent,
      Value<bool>? isUser,
      Value<int>? timestamp,
      Value<String>? citedNotesJson,
      Value<String?>? pendingActionJson,
      Value<String?>? actionExecutedMessage,
      Value<int>? rowid}) {
    return ChatMessagesTableCompanion(
      id: id ?? this.id,
      textContent: textContent ?? this.textContent,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      citedNotesJson: citedNotesJson ?? this.citedNotesJson,
      pendingActionJson: pendingActionJson ?? this.pendingActionJson,
      actionExecutedMessage:
          actionExecutedMessage ?? this.actionExecutedMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (isUser.present) {
      map['is_user'] = Variable<bool>(isUser.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (citedNotesJson.present) {
      map['cited_notes_json'] = Variable<String>(citedNotesJson.value);
    }
    if (pendingActionJson.present) {
      map['pending_action_json'] = Variable<String>(pendingActionJson.value);
    }
    if (actionExecutedMessage.present) {
      map['action_executed_message'] =
          Variable<String>(actionExecutedMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('textContent: $textContent, ')
          ..write('isUser: $isUser, ')
          ..write('timestamp: $timestamp, ')
          ..write('citedNotesJson: $citedNotesJson, ')
          ..write('pendingActionJson: $pendingActionJson, ')
          ..write('actionExecutedMessage: $actionExecutedMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntitiesTableTable extends EntitiesTable
    with TableInfo<$EntitiesTableTable, EntitiesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitiesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _canonicalNameMeta =
      const VerificationMeta('canonicalName');
  @override
  late final GeneratedColumn<String> canonicalName = GeneratedColumn<String>(
      'canonical_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _aliasesJsonMeta =
      const VerificationMeta('aliasesJson');
  @override
  late final GeneratedColumn<String> aliasesJson = GeneratedColumn<String>(
      'aliases_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, canonicalName, aliasesJson, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entities';
  @override
  VerificationContext validateIntegrity(Insertable<EntitiesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('canonical_name')) {
      context.handle(
          _canonicalNameMeta,
          canonicalName.isAcceptableOrUnknown(
              data['canonical_name']!, _canonicalNameMeta));
    } else if (isInserting) {
      context.missing(_canonicalNameMeta);
    }
    if (data.containsKey('aliases_json')) {
      context.handle(
          _aliasesJsonMeta,
          aliasesJson.isAcceptableOrUnknown(
              data['aliases_json']!, _aliasesJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntitiesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntitiesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      canonicalName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}canonical_name'])!,
      aliasesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aliases_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $EntitiesTableTable createAlias(String alias) {
    return $EntitiesTableTable(attachedDatabase, alias);
  }
}

class EntitiesTableData extends DataClass
    implements Insertable<EntitiesTableData> {
  final String id;
  final String name;

  /// Entity type: 'person', 'project', 'technology', 'organization', 'concept', 'location'
  final String type;

  /// Normalized lowercase representation for fast deterministic matching
  final String canonicalName;

  /// Comma-separated or JSON list of known aliases/alternative spellings
  final String aliasesJson;
  final int createdAt;
  final int updatedAt;
  const EntitiesTableData(
      {required this.id,
      required this.name,
      required this.type,
      required this.canonicalName,
      required this.aliasesJson,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['canonical_name'] = Variable<String>(canonicalName);
    map['aliases_json'] = Variable<String>(aliasesJson);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  EntitiesTableCompanion toCompanion(bool nullToAbsent) {
    return EntitiesTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      canonicalName: Value(canonicalName),
      aliasesJson: Value(aliasesJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EntitiesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntitiesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      canonicalName: serializer.fromJson<String>(json['canonicalName']),
      aliasesJson: serializer.fromJson<String>(json['aliasesJson']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'canonicalName': serializer.toJson<String>(canonicalName),
      'aliasesJson': serializer.toJson<String>(aliasesJson),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  EntitiesTableData copyWith(
          {String? id,
          String? name,
          String? type,
          String? canonicalName,
          String? aliasesJson,
          int? createdAt,
          int? updatedAt}) =>
      EntitiesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        canonicalName: canonicalName ?? this.canonicalName,
        aliasesJson: aliasesJson ?? this.aliasesJson,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  EntitiesTableData copyWithCompanion(EntitiesTableCompanion data) {
    return EntitiesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      canonicalName: data.canonicalName.present
          ? data.canonicalName.value
          : this.canonicalName,
      aliasesJson:
          data.aliasesJson.present ? data.aliasesJson.value : this.aliasesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('canonicalName: $canonicalName, ')
          ..write('aliasesJson: $aliasesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, type, canonicalName, aliasesJson, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntitiesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.canonicalName == this.canonicalName &&
          other.aliasesJson == this.aliasesJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EntitiesTableCompanion extends UpdateCompanion<EntitiesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> canonicalName;
  final Value<String> aliasesJson;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const EntitiesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.canonicalName = const Value.absent(),
    this.aliasesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitiesTableCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String canonicalName,
    this.aliasesJson = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        canonicalName = Value(canonicalName),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<EntitiesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? canonicalName,
    Expression<String>? aliasesJson,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (canonicalName != null) 'canonical_name': canonicalName,
      if (aliasesJson != null) 'aliases_json': aliasesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitiesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? canonicalName,
      Value<String>? aliasesJson,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return EntitiesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      canonicalName: canonicalName ?? this.canonicalName,
      aliasesJson: aliasesJson ?? this.aliasesJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (canonicalName.present) {
      map['canonical_name'] = Variable<String>(canonicalName.value);
    }
    if (aliasesJson.present) {
      map['aliases_json'] = Variable<String>(aliasesJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('canonicalName: $canonicalName, ')
          ..write('aliasesJson: $aliasesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RelationshipsTableTable extends RelationshipsTable
    with TableInfo<$RelationshipsTableTable, RelationshipsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationshipsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceEntityIdMeta =
      const VerificationMeta('sourceEntityId');
  @override
  late final GeneratedColumn<String> sourceEntityId = GeneratedColumn<String>(
      'source_entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationMeta =
      const VerificationMeta('relation');
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
      'relation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetEntityIdMeta =
      const VerificationMeta('targetEntityId');
  @override
  late final GeneratedColumn<String> targetEntityId = GeneratedColumn<String>(
      'target_entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMemoryIdMeta =
      const VerificationMeta('sourceMemoryId');
  @override
  late final GeneratedColumn<String> sourceMemoryId = GeneratedColumn<String>(
      'source_memory_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sourceEntityId,
        relation,
        targetEntityId,
        sourceMemoryId,
        confidence,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relationships';
  @override
  VerificationContext validateIntegrity(
      Insertable<RelationshipsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_entity_id')) {
      context.handle(
          _sourceEntityIdMeta,
          sourceEntityId.isAcceptableOrUnknown(
              data['source_entity_id']!, _sourceEntityIdMeta));
    } else if (isInserting) {
      context.missing(_sourceEntityIdMeta);
    }
    if (data.containsKey('relation')) {
      context.handle(_relationMeta,
          relation.isAcceptableOrUnknown(data['relation']!, _relationMeta));
    } else if (isInserting) {
      context.missing(_relationMeta);
    }
    if (data.containsKey('target_entity_id')) {
      context.handle(
          _targetEntityIdMeta,
          targetEntityId.isAcceptableOrUnknown(
              data['target_entity_id']!, _targetEntityIdMeta));
    } else if (isInserting) {
      context.missing(_targetEntityIdMeta);
    }
    if (data.containsKey('source_memory_id')) {
      context.handle(
          _sourceMemoryIdMeta,
          sourceMemoryId.isAcceptableOrUnknown(
              data['source_memory_id']!, _sourceMemoryIdMeta));
    } else if (isInserting) {
      context.missing(_sourceMemoryIdMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelationshipsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelationshipsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_entity_id'])!,
      relation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation'])!,
      targetEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_entity_id'])!,
      sourceMemoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_memory_id'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RelationshipsTableTable createAlias(String alias) {
    return $RelationshipsTableTable(attachedDatabase, alias);
  }
}

class RelationshipsTableData extends DataClass
    implements Insertable<RelationshipsTableData> {
  final String id;

  /// Foreign key to source entity (e.g. Arun)
  final String sourceEntityId;

  /// Predicate/relationship label (e.g. 'suggested', 'works_on', 'helps_with', 'used_in')
  final String relation;

  /// Foreign key to target entity (e.g. Gemma 3 1B)
  final String targetEntityId;

  /// Foreign key to note/memory ID where this fact was stated
  final String sourceMemoryId;

  /// Confidence score (0.0 to 1.0)
  final double confidence;
  final int createdAt;
  final int updatedAt;
  const RelationshipsTableData(
      {required this.id,
      required this.sourceEntityId,
      required this.relation,
      required this.targetEntityId,
      required this.sourceMemoryId,
      required this.confidence,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_entity_id'] = Variable<String>(sourceEntityId);
    map['relation'] = Variable<String>(relation);
    map['target_entity_id'] = Variable<String>(targetEntityId);
    map['source_memory_id'] = Variable<String>(sourceMemoryId);
    map['confidence'] = Variable<double>(confidence);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RelationshipsTableCompanion toCompanion(bool nullToAbsent) {
    return RelationshipsTableCompanion(
      id: Value(id),
      sourceEntityId: Value(sourceEntityId),
      relation: Value(relation),
      targetEntityId: Value(targetEntityId),
      sourceMemoryId: Value(sourceMemoryId),
      confidence: Value(confidence),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RelationshipsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelationshipsTableData(
      id: serializer.fromJson<String>(json['id']),
      sourceEntityId: serializer.fromJson<String>(json['sourceEntityId']),
      relation: serializer.fromJson<String>(json['relation']),
      targetEntityId: serializer.fromJson<String>(json['targetEntityId']),
      sourceMemoryId: serializer.fromJson<String>(json['sourceMemoryId']),
      confidence: serializer.fromJson<double>(json['confidence']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceEntityId': serializer.toJson<String>(sourceEntityId),
      'relation': serializer.toJson<String>(relation),
      'targetEntityId': serializer.toJson<String>(targetEntityId),
      'sourceMemoryId': serializer.toJson<String>(sourceMemoryId),
      'confidence': serializer.toJson<double>(confidence),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RelationshipsTableData copyWith(
          {String? id,
          String? sourceEntityId,
          String? relation,
          String? targetEntityId,
          String? sourceMemoryId,
          double? confidence,
          int? createdAt,
          int? updatedAt}) =>
      RelationshipsTableData(
        id: id ?? this.id,
        sourceEntityId: sourceEntityId ?? this.sourceEntityId,
        relation: relation ?? this.relation,
        targetEntityId: targetEntityId ?? this.targetEntityId,
        sourceMemoryId: sourceMemoryId ?? this.sourceMemoryId,
        confidence: confidence ?? this.confidence,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RelationshipsTableData copyWithCompanion(RelationshipsTableCompanion data) {
    return RelationshipsTableData(
      id: data.id.present ? data.id.value : this.id,
      sourceEntityId: data.sourceEntityId.present
          ? data.sourceEntityId.value
          : this.sourceEntityId,
      relation: data.relation.present ? data.relation.value : this.relation,
      targetEntityId: data.targetEntityId.present
          ? data.targetEntityId.value
          : this.targetEntityId,
      sourceMemoryId: data.sourceMemoryId.present
          ? data.sourceMemoryId.value
          : this.sourceMemoryId,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipsTableData(')
          ..write('id: $id, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('relation: $relation, ')
          ..write('targetEntityId: $targetEntityId, ')
          ..write('sourceMemoryId: $sourceMemoryId, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sourceEntityId, relation, targetEntityId,
      sourceMemoryId, confidence, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelationshipsTableData &&
          other.id == this.id &&
          other.sourceEntityId == this.sourceEntityId &&
          other.relation == this.relation &&
          other.targetEntityId == this.targetEntityId &&
          other.sourceMemoryId == this.sourceMemoryId &&
          other.confidence == this.confidence &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RelationshipsTableCompanion
    extends UpdateCompanion<RelationshipsTableData> {
  final Value<String> id;
  final Value<String> sourceEntityId;
  final Value<String> relation;
  final Value<String> targetEntityId;
  final Value<String> sourceMemoryId;
  final Value<double> confidence;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RelationshipsTableCompanion({
    this.id = const Value.absent(),
    this.sourceEntityId = const Value.absent(),
    this.relation = const Value.absent(),
    this.targetEntityId = const Value.absent(),
    this.sourceMemoryId = const Value.absent(),
    this.confidence = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelationshipsTableCompanion.insert({
    required String id,
    required String sourceEntityId,
    required String relation,
    required String targetEntityId,
    required String sourceMemoryId,
    this.confidence = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceEntityId = Value(sourceEntityId),
        relation = Value(relation),
        targetEntityId = Value(targetEntityId),
        sourceMemoryId = Value(sourceMemoryId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RelationshipsTableData> custom({
    Expression<String>? id,
    Expression<String>? sourceEntityId,
    Expression<String>? relation,
    Expression<String>? targetEntityId,
    Expression<String>? sourceMemoryId,
    Expression<double>? confidence,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceEntityId != null) 'source_entity_id': sourceEntityId,
      if (relation != null) 'relation': relation,
      if (targetEntityId != null) 'target_entity_id': targetEntityId,
      if (sourceMemoryId != null) 'source_memory_id': sourceMemoryId,
      if (confidence != null) 'confidence': confidence,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelationshipsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? sourceEntityId,
      Value<String>? relation,
      Value<String>? targetEntityId,
      Value<String>? sourceMemoryId,
      Value<double>? confidence,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return RelationshipsTableCompanion(
      id: id ?? this.id,
      sourceEntityId: sourceEntityId ?? this.sourceEntityId,
      relation: relation ?? this.relation,
      targetEntityId: targetEntityId ?? this.targetEntityId,
      sourceMemoryId: sourceMemoryId ?? this.sourceMemoryId,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceEntityId.present) {
      map['source_entity_id'] = Variable<String>(sourceEntityId.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
    }
    if (targetEntityId.present) {
      map['target_entity_id'] = Variable<String>(targetEntityId.value);
    }
    if (sourceMemoryId.present) {
      map['source_memory_id'] = Variable<String>(sourceMemoryId.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipsTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('relation: $relation, ')
          ..write('targetEntityId: $targetEntityId, ')
          ..write('sourceMemoryId: $sourceMemoryId, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memoryIdMeta =
      const VerificationMeta('memoryId');
  @override
  late final GeneratedColumn<String> memoryId = GeneratedColumn<String>(
      'memory_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueTimestampMeta =
      const VerificationMeta('dueTimestamp');
  @override
  late final GeneratedColumn<int> dueTimestamp = GeneratedColumn<int>(
      'due_timestamp', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        memoryId,
        description,
        dueDate,
        dueTimestamp,
        isCompleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<TasksTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('memory_id')) {
      context.handle(_memoryIdMeta,
          memoryId.isAcceptableOrUnknown(data['memory_id']!, _memoryIdMeta));
    } else if (isInserting) {
      context.missing(_memoryIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('due_timestamp')) {
      context.handle(
          _dueTimestampMeta,
          dueTimestamp.isAcceptableOrUnknown(
              data['due_timestamp']!, _dueTimestampMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      memoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memory_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_date']),
      dueTimestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_timestamp']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class TasksTableData extends DataClass implements Insertable<TasksTableData> {
  final String id;

  /// Foreign key to the note/memory from which this task was extracted
  final String memoryId;
  final String description;

  /// Raw or parsed due date string (e.g. 'tomorrow', '2026-08-13T09:00:00')
  final String? dueDate;

  /// Parsed epoch millis if successfully parsed by DateTimeParser
  final int? dueTimestamp;
  final bool isCompleted;
  final int createdAt;
  final int updatedAt;
  const TasksTableData(
      {required this.id,
      required this.memoryId,
      required this.description,
      this.dueDate,
      this.dueTimestamp,
      required this.isCompleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['memory_id'] = Variable<String>(memoryId);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || dueTimestamp != null) {
      map['due_timestamp'] = Variable<int>(dueTimestamp);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      memoryId: Value(memoryId),
      description: Value(description),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueTimestamp: dueTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTimestamp),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TasksTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksTableData(
      id: serializer.fromJson<String>(json['id']),
      memoryId: serializer.fromJson<String>(json['memoryId']),
      description: serializer.fromJson<String>(json['description']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      dueTimestamp: serializer.fromJson<int?>(json['dueTimestamp']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memoryId': serializer.toJson<String>(memoryId),
      'description': serializer.toJson<String>(description),
      'dueDate': serializer.toJson<String?>(dueDate),
      'dueTimestamp': serializer.toJson<int?>(dueTimestamp),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  TasksTableData copyWith(
          {String? id,
          String? memoryId,
          String? description,
          Value<String?> dueDate = const Value.absent(),
          Value<int?> dueTimestamp = const Value.absent(),
          bool? isCompleted,
          int? createdAt,
          int? updatedAt}) =>
      TasksTableData(
        id: id ?? this.id,
        memoryId: memoryId ?? this.memoryId,
        description: description ?? this.description,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        dueTimestamp:
            dueTimestamp.present ? dueTimestamp.value : this.dueTimestamp,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TasksTableData copyWithCompanion(TasksTableCompanion data) {
    return TasksTableData(
      id: data.id.present ? data.id.value : this.id,
      memoryId: data.memoryId.present ? data.memoryId.value : this.memoryId,
      description:
          data.description.present ? data.description.value : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTimestamp: data.dueTimestamp.present
          ? data.dueTimestamp.value
          : this.dueTimestamp,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableData(')
          ..write('id: $id, ')
          ..write('memoryId: $memoryId, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTimestamp: $dueTimestamp, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, memoryId, description, dueDate,
      dueTimestamp, isCompleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksTableData &&
          other.id == this.id &&
          other.memoryId == this.memoryId &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.dueTimestamp == this.dueTimestamp &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksTableCompanion extends UpdateCompanion<TasksTableData> {
  final Value<String> id;
  final Value<String> memoryId;
  final Value<String> description;
  final Value<String?> dueDate;
  final Value<int?> dueTimestamp;
  final Value<bool> isCompleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.memoryId = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTimestamp = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String memoryId,
    required String description,
    this.dueDate = const Value.absent(),
    this.dueTimestamp = const Value.absent(),
    this.isCompleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        memoryId = Value(memoryId),
        description = Value(description),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TasksTableData> custom({
    Expression<String>? id,
    Expression<String>? memoryId,
    Expression<String>? description,
    Expression<String>? dueDate,
    Expression<int>? dueTimestamp,
    Expression<bool>? isCompleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memoryId != null) 'memory_id': memoryId,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTimestamp != null) 'due_timestamp': dueTimestamp,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? memoryId,
      Value<String>? description,
      Value<String?>? dueDate,
      Value<int?>? dueTimestamp,
      Value<bool>? isCompleted,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return TasksTableCompanion(
      id: id ?? this.id,
      memoryId: memoryId ?? this.memoryId,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTimestamp: dueTimestamp ?? this.dueTimestamp,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memoryId.present) {
      map['memory_id'] = Variable<String>(memoryId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (dueTimestamp.present) {
      map['due_timestamp'] = Variable<int>(dueTimestamp.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('memoryId: $memoryId, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTimestamp: $dueTimestamp, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryEntitiesTableTable extends MemoryEntitiesTable
    with TableInfo<$MemoryEntitiesTableTable, MemoryEntitiesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryEntitiesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _memoryIdMeta =
      const VerificationMeta('memoryId');
  @override
  late final GeneratedColumn<String> memoryId = GeneratedColumn<String>(
      'memory_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('mentioned'));
  @override
  List<GeneratedColumn> get $columns => [memoryId, entityId, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_entities';
  @override
  VerificationContext validateIntegrity(
      Insertable<MemoryEntitiesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('memory_id')) {
      context.handle(_memoryIdMeta,
          memoryId.isAcceptableOrUnknown(data['memory_id']!, _memoryIdMeta));
    } else if (isInserting) {
      context.missing(_memoryIdMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {memoryId, entityId};
  @override
  MemoryEntitiesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryEntitiesTableData(
      memoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memory_id'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
    );
  }

  @override
  $MemoryEntitiesTableTable createAlias(String alias) {
    return $MemoryEntitiesTableTable(attachedDatabase, alias);
  }
}

class MemoryEntitiesTableData extends DataClass
    implements Insertable<MemoryEntitiesTableData> {
  final String memoryId;
  final String entityId;

  /// Role of the entity in this memory (e.g. 'subject', 'mentioned', 'creator')
  final String role;
  const MemoryEntitiesTableData(
      {required this.memoryId, required this.entityId, required this.role});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['memory_id'] = Variable<String>(memoryId);
    map['entity_id'] = Variable<String>(entityId);
    map['role'] = Variable<String>(role);
    return map;
  }

  MemoryEntitiesTableCompanion toCompanion(bool nullToAbsent) {
    return MemoryEntitiesTableCompanion(
      memoryId: Value(memoryId),
      entityId: Value(entityId),
      role: Value(role),
    );
  }

  factory MemoryEntitiesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryEntitiesTableData(
      memoryId: serializer.fromJson<String>(json['memoryId']),
      entityId: serializer.fromJson<String>(json['entityId']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'memoryId': serializer.toJson<String>(memoryId),
      'entityId': serializer.toJson<String>(entityId),
      'role': serializer.toJson<String>(role),
    };
  }

  MemoryEntitiesTableData copyWith(
          {String? memoryId, String? entityId, String? role}) =>
      MemoryEntitiesTableData(
        memoryId: memoryId ?? this.memoryId,
        entityId: entityId ?? this.entityId,
        role: role ?? this.role,
      );
  MemoryEntitiesTableData copyWithCompanion(MemoryEntitiesTableCompanion data) {
    return MemoryEntitiesTableData(
      memoryId: data.memoryId.present ? data.memoryId.value : this.memoryId,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEntitiesTableData(')
          ..write('memoryId: $memoryId, ')
          ..write('entityId: $entityId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(memoryId, entityId, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryEntitiesTableData &&
          other.memoryId == this.memoryId &&
          other.entityId == this.entityId &&
          other.role == this.role);
}

class MemoryEntitiesTableCompanion
    extends UpdateCompanion<MemoryEntitiesTableData> {
  final Value<String> memoryId;
  final Value<String> entityId;
  final Value<String> role;
  final Value<int> rowid;
  const MemoryEntitiesTableCompanion({
    this.memoryId = const Value.absent(),
    this.entityId = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryEntitiesTableCompanion.insert({
    required String memoryId,
    required String entityId,
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : memoryId = Value(memoryId),
        entityId = Value(entityId);
  static Insertable<MemoryEntitiesTableData> custom({
    Expression<String>? memoryId,
    Expression<String>? entityId,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (memoryId != null) 'memory_id': memoryId,
      if (entityId != null) 'entity_id': entityId,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryEntitiesTableCompanion copyWith(
      {Value<String>? memoryId,
      Value<String>? entityId,
      Value<String>? role,
      Value<int>? rowid}) {
    return MemoryEntitiesTableCompanion(
      memoryId: memoryId ?? this.memoryId,
      entityId: entityId ?? this.entityId,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (memoryId.present) {
      map['memory_id'] = Variable<String>(memoryId.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEntitiesTableCompanion(')
          ..write('memoryId: $memoryId, ')
          ..write('entityId: $entityId, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  late final $EmbeddingsTableTable embeddingsTable =
      $EmbeddingsTableTable(this);
  late final $ClustersTableTable clustersTable = $ClustersTableTable(this);
  late final $ChatMessagesTableTable chatMessagesTable =
      $ChatMessagesTableTable(this);
  late final $EntitiesTableTable entitiesTable = $EntitiesTableTable(this);
  late final $RelationshipsTableTable relationshipsTable =
      $RelationshipsTableTable(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $MemoryEntitiesTableTable memoryEntitiesTable =
      $MemoryEntitiesTableTable(this);
  late final NotesDao notesDao = NotesDao(this as AppDatabase);
  late final EmbeddingsDao embeddingsDao = EmbeddingsDao(this as AppDatabase);
  late final ClustersDao clustersDao = ClustersDao(this as AppDatabase);
  late final ChatMessagesDao chatMessagesDao =
      ChatMessagesDao(this as AppDatabase);
  late final EntitiesDao entitiesDao = EntitiesDao(this as AppDatabase);
  late final RelationshipsDao relationshipsDao =
      RelationshipsDao(this as AppDatabase);
  late final TasksDao tasksDao = TasksDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        notesTable,
        embeddingsTable,
        clustersTable,
        chatMessagesTable,
        entitiesTable,
        relationshipsTable,
        tasksTable,
        memoryEntitiesTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('notes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('embeddings', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$NotesTableTableCreateCompanionBuilder = NotesTableCompanion Function({
  required String id,
  required String content,
  Value<String?> summary,
  Value<String> keywordsJson,
  Value<String?> clusterId,
  Value<String> relatedNoteIdsJson,
  Value<String> processingStatus,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$NotesTableTableUpdateCompanionBuilder = NotesTableCompanion Function({
  Value<String> id,
  Value<String> content,
  Value<String?> summary,
  Value<String> keywordsJson,
  Value<String?> clusterId,
  Value<String> relatedNoteIdsJson,
  Value<String> processingStatus,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$NotesTableTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTableTable, NotesTableData> {
  $$NotesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EmbeddingsTableTable, List<EmbeddingsTableData>>
      _embeddingsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.embeddingsTable,
              aliasName: $_aliasNameGenerator(
                  db.notesTable.id, db.embeddingsTable.noteId));

  $$EmbeddingsTableTableProcessedTableManager get embeddingsTableRefs {
    final manager =
        $$EmbeddingsTableTableTableManager($_db, $_db.embeddingsTable)
            .filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_embeddingsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$NotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keywordsJson => $composableBuilder(
      column: $table.keywordsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clusterId => $composableBuilder(
      column: $table.clusterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedNoteIdsJson => $composableBuilder(
      column: $table.relatedNoteIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get processingStatus => $composableBuilder(
      column: $table.processingStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> embeddingsTableRefs(
      Expression<bool> Function($$EmbeddingsTableTableFilterComposer f) f) {
    final $$EmbeddingsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.embeddingsTable,
        getReferencedColumn: (t) => t.noteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmbeddingsTableTableFilterComposer(
              $db: $db,
              $table: $db.embeddingsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keywordsJson => $composableBuilder(
      column: $table.keywordsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clusterId => $composableBuilder(
      column: $table.clusterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedNoteIdsJson => $composableBuilder(
      column: $table.relatedNoteIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get processingStatus => $composableBuilder(
      column: $table.processingStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get keywordsJson => $composableBuilder(
      column: $table.keywordsJson, builder: (column) => column);

  GeneratedColumn<String> get clusterId =>
      $composableBuilder(column: $table.clusterId, builder: (column) => column);

  GeneratedColumn<String> get relatedNoteIdsJson => $composableBuilder(
      column: $table.relatedNoteIdsJson, builder: (column) => column);

  GeneratedColumn<String> get processingStatus => $composableBuilder(
      column: $table.processingStatus, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> embeddingsTableRefs<T extends Object>(
      Expression<T> Function($$EmbeddingsTableTableAnnotationComposer a) f) {
    final $$EmbeddingsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.embeddingsTable,
        getReferencedColumn: (t) => t.noteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmbeddingsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.embeddingsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NotesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTableTable,
    NotesTableData,
    $$NotesTableTableFilterComposer,
    $$NotesTableTableOrderingComposer,
    $$NotesTableTableAnnotationComposer,
    $$NotesTableTableCreateCompanionBuilder,
    $$NotesTableTableUpdateCompanionBuilder,
    (NotesTableData, $$NotesTableTableReferences),
    NotesTableData,
    PrefetchHooks Function({bool embeddingsTableRefs})> {
  $$NotesTableTableTableManager(_$AppDatabase db, $NotesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String> keywordsJson = const Value.absent(),
            Value<String?> clusterId = const Value.absent(),
            Value<String> relatedNoteIdsJson = const Value.absent(),
            Value<String> processingStatus = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion(
            id: id,
            content: content,
            summary: summary,
            keywordsJson: keywordsJson,
            clusterId: clusterId,
            relatedNoteIdsJson: relatedNoteIdsJson,
            processingStatus: processingStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String content,
            Value<String?> summary = const Value.absent(),
            Value<String> keywordsJson = const Value.absent(),
            Value<String?> clusterId = const Value.absent(),
            Value<String> relatedNoteIdsJson = const Value.absent(),
            Value<String> processingStatus = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion.insert(
            id: id,
            content: content,
            summary: summary,
            keywordsJson: keywordsJson,
            clusterId: clusterId,
            relatedNoteIdsJson: relatedNoteIdsJson,
            processingStatus: processingStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NotesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({embeddingsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (embeddingsTableRefs) db.embeddingsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (embeddingsTableRefs)
                    await $_getPrefetchedData<NotesTableData, $NotesTableTable,
                            EmbeddingsTableData>(
                        currentTable: table,
                        referencedTable: $$NotesTableTableReferences
                            ._embeddingsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NotesTableTableReferences(db, table, p0)
                                .embeddingsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.noteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$NotesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTableTable,
    NotesTableData,
    $$NotesTableTableFilterComposer,
    $$NotesTableTableOrderingComposer,
    $$NotesTableTableAnnotationComposer,
    $$NotesTableTableCreateCompanionBuilder,
    $$NotesTableTableUpdateCompanionBuilder,
    (NotesTableData, $$NotesTableTableReferences),
    NotesTableData,
    PrefetchHooks Function({bool embeddingsTableRefs})>;
typedef $$EmbeddingsTableTableCreateCompanionBuilder = EmbeddingsTableCompanion
    Function({
  required String noteId,
  required Uint8List vector,
  Value<int> rowid,
});
typedef $$EmbeddingsTableTableUpdateCompanionBuilder = EmbeddingsTableCompanion
    Function({
  Value<String> noteId,
  Value<Uint8List> vector,
  Value<int> rowid,
});

final class $$EmbeddingsTableTableReferences extends BaseReferences<
    _$AppDatabase, $EmbeddingsTableTable, EmbeddingsTableData> {
  $$EmbeddingsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $NotesTableTable _noteIdTable(_$AppDatabase db) =>
      db.notesTable.createAlias(
          $_aliasNameGenerator(db.embeddingsTable.noteId, db.notesTable.id));

  $$NotesTableTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$NotesTableTableTableManager($_db, $_db.notesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EmbeddingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmbeddingsTableTable> {
  $$EmbeddingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<Uint8List> get vector => $composableBuilder(
      column: $table.vector, builder: (column) => ColumnFilters(column));

  $$NotesTableTableFilterComposer get noteId {
    final $$NotesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.notesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableTableFilterComposer(
              $db: $db,
              $table: $db.notesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EmbeddingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmbeddingsTableTable> {
  $$EmbeddingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<Uint8List> get vector => $composableBuilder(
      column: $table.vector, builder: (column) => ColumnOrderings(column));

  $$NotesTableTableOrderingComposer get noteId {
    final $$NotesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.notesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableTableOrderingComposer(
              $db: $db,
              $table: $db.notesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EmbeddingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmbeddingsTableTable> {
  $$EmbeddingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<Uint8List> get vector =>
      $composableBuilder(column: $table.vector, builder: (column) => column);

  $$NotesTableTableAnnotationComposer get noteId {
    final $$NotesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.notesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.notesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EmbeddingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmbeddingsTableTable,
    EmbeddingsTableData,
    $$EmbeddingsTableTableFilterComposer,
    $$EmbeddingsTableTableOrderingComposer,
    $$EmbeddingsTableTableAnnotationComposer,
    $$EmbeddingsTableTableCreateCompanionBuilder,
    $$EmbeddingsTableTableUpdateCompanionBuilder,
    (EmbeddingsTableData, $$EmbeddingsTableTableReferences),
    EmbeddingsTableData,
    PrefetchHooks Function({bool noteId})> {
  $$EmbeddingsTableTableTableManager(
      _$AppDatabase db, $EmbeddingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmbeddingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmbeddingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmbeddingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> noteId = const Value.absent(),
            Value<Uint8List> vector = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmbeddingsTableCompanion(
            noteId: noteId,
            vector: vector,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String noteId,
            required Uint8List vector,
            Value<int> rowid = const Value.absent(),
          }) =>
              EmbeddingsTableCompanion.insert(
            noteId: noteId,
            vector: vector,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EmbeddingsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (noteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.noteId,
                    referencedTable:
                        $$EmbeddingsTableTableReferences._noteIdTable(db),
                    referencedColumn:
                        $$EmbeddingsTableTableReferences._noteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EmbeddingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmbeddingsTableTable,
    EmbeddingsTableData,
    $$EmbeddingsTableTableFilterComposer,
    $$EmbeddingsTableTableOrderingComposer,
    $$EmbeddingsTableTableAnnotationComposer,
    $$EmbeddingsTableTableCreateCompanionBuilder,
    $$EmbeddingsTableTableUpdateCompanionBuilder,
    (EmbeddingsTableData, $$EmbeddingsTableTableReferences),
    EmbeddingsTableData,
    PrefetchHooks Function({bool noteId})>;
typedef $$ClustersTableTableCreateCompanionBuilder = ClustersTableCompanion
    Function({
  required String id,
  required String name,
  required String colorHex,
  required int createdAt,
  Value<int> rowid,
});
typedef $$ClustersTableTableUpdateCompanionBuilder = ClustersTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> colorHex,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$ClustersTableTableFilterComposer
    extends Composer<_$AppDatabase, $ClustersTableTable> {
  $$ClustersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ClustersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ClustersTableTable> {
  $$ClustersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ClustersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClustersTableTable> {
  $$ClustersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ClustersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClustersTableTable,
    ClustersTableData,
    $$ClustersTableTableFilterComposer,
    $$ClustersTableTableOrderingComposer,
    $$ClustersTableTableAnnotationComposer,
    $$ClustersTableTableCreateCompanionBuilder,
    $$ClustersTableTableUpdateCompanionBuilder,
    (
      ClustersTableData,
      BaseReferences<_$AppDatabase, $ClustersTableTable, ClustersTableData>
    ),
    ClustersTableData,
    PrefetchHooks Function()> {
  $$ClustersTableTableTableManager(_$AppDatabase db, $ClustersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClustersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClustersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClustersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClustersTableCompanion(
            id: id,
            name: name,
            colorHex: colorHex,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String colorHex,
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ClustersTableCompanion.insert(
            id: id,
            name: name,
            colorHex: colorHex,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClustersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClustersTableTable,
    ClustersTableData,
    $$ClustersTableTableFilterComposer,
    $$ClustersTableTableOrderingComposer,
    $$ClustersTableTableAnnotationComposer,
    $$ClustersTableTableCreateCompanionBuilder,
    $$ClustersTableTableUpdateCompanionBuilder,
    (
      ClustersTableData,
      BaseReferences<_$AppDatabase, $ClustersTableTable, ClustersTableData>
    ),
    ClustersTableData,
    PrefetchHooks Function()>;
typedef $$ChatMessagesTableTableCreateCompanionBuilder
    = ChatMessagesTableCompanion Function({
  required String id,
  required String textContent,
  required bool isUser,
  required int timestamp,
  Value<String> citedNotesJson,
  Value<String?> pendingActionJson,
  Value<String?> actionExecutedMessage,
  Value<int> rowid,
});
typedef $$ChatMessagesTableTableUpdateCompanionBuilder
    = ChatMessagesTableCompanion Function({
  Value<String> id,
  Value<String> textContent,
  Value<bool> isUser,
  Value<int> timestamp,
  Value<String> citedNotesJson,
  Value<String?> pendingActionJson,
  Value<String?> actionExecutedMessage,
  Value<int> rowid,
});

class $$ChatMessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTableTable> {
  $$ChatMessagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUser => $composableBuilder(
      column: $table.isUser, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get citedNotesJson => $composableBuilder(
      column: $table.citedNotesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pendingActionJson => $composableBuilder(
      column: $table.pendingActionJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionExecutedMessage => $composableBuilder(
      column: $table.actionExecutedMessage,
      builder: (column) => ColumnFilters(column));
}

class $$ChatMessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTableTable> {
  $$ChatMessagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUser => $composableBuilder(
      column: $table.isUser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get citedNotesJson => $composableBuilder(
      column: $table.citedNotesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pendingActionJson => $composableBuilder(
      column: $table.pendingActionJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionExecutedMessage => $composableBuilder(
      column: $table.actionExecutedMessage,
      builder: (column) => ColumnOrderings(column));
}

class $$ChatMessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTableTable> {
  $$ChatMessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);

  GeneratedColumn<bool> get isUser =>
      $composableBuilder(column: $table.isUser, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get citedNotesJson => $composableBuilder(
      column: $table.citedNotesJson, builder: (column) => column);

  GeneratedColumn<String> get pendingActionJson => $composableBuilder(
      column: $table.pendingActionJson, builder: (column) => column);

  GeneratedColumn<String> get actionExecutedMessage => $composableBuilder(
      column: $table.actionExecutedMessage, builder: (column) => column);
}

class $$ChatMessagesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesTableTable,
    ChatMessagesTableData,
    $$ChatMessagesTableTableFilterComposer,
    $$ChatMessagesTableTableOrderingComposer,
    $$ChatMessagesTableTableAnnotationComposer,
    $$ChatMessagesTableTableCreateCompanionBuilder,
    $$ChatMessagesTableTableUpdateCompanionBuilder,
    (
      ChatMessagesTableData,
      BaseReferences<_$AppDatabase, $ChatMessagesTableTable,
          ChatMessagesTableData>
    ),
    ChatMessagesTableData,
    PrefetchHooks Function()> {
  $$ChatMessagesTableTableTableManager(
      _$AppDatabase db, $ChatMessagesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> textContent = const Value.absent(),
            Value<bool> isUser = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<String> citedNotesJson = const Value.absent(),
            Value<String?> pendingActionJson = const Value.absent(),
            Value<String?> actionExecutedMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesTableCompanion(
            id: id,
            textContent: textContent,
            isUser: isUser,
            timestamp: timestamp,
            citedNotesJson: citedNotesJson,
            pendingActionJson: pendingActionJson,
            actionExecutedMessage: actionExecutedMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String textContent,
            required bool isUser,
            required int timestamp,
            Value<String> citedNotesJson = const Value.absent(),
            Value<String?> pendingActionJson = const Value.absent(),
            Value<String?> actionExecutedMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesTableCompanion.insert(
            id: id,
            textContent: textContent,
            isUser: isUser,
            timestamp: timestamp,
            citedNotesJson: citedNotesJson,
            pendingActionJson: pendingActionJson,
            actionExecutedMessage: actionExecutedMessage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatMessagesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesTableTable,
    ChatMessagesTableData,
    $$ChatMessagesTableTableFilterComposer,
    $$ChatMessagesTableTableOrderingComposer,
    $$ChatMessagesTableTableAnnotationComposer,
    $$ChatMessagesTableTableCreateCompanionBuilder,
    $$ChatMessagesTableTableUpdateCompanionBuilder,
    (
      ChatMessagesTableData,
      BaseReferences<_$AppDatabase, $ChatMessagesTableTable,
          ChatMessagesTableData>
    ),
    ChatMessagesTableData,
    PrefetchHooks Function()>;
typedef $$EntitiesTableTableCreateCompanionBuilder = EntitiesTableCompanion
    Function({
  required String id,
  required String name,
  required String type,
  required String canonicalName,
  Value<String> aliasesJson,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$EntitiesTableTableUpdateCompanionBuilder = EntitiesTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> canonicalName,
  Value<String> aliasesJson,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$EntitiesTableTableFilterComposer
    extends Composer<_$AppDatabase, $EntitiesTableTable> {
  $$EntitiesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get canonicalName => $composableBuilder(
      column: $table.canonicalName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aliasesJson => $composableBuilder(
      column: $table.aliasesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$EntitiesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EntitiesTableTable> {
  $$EntitiesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get canonicalName => $composableBuilder(
      column: $table.canonicalName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aliasesJson => $composableBuilder(
      column: $table.aliasesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$EntitiesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntitiesTableTable> {
  $$EntitiesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get canonicalName => $composableBuilder(
      column: $table.canonicalName, builder: (column) => column);

  GeneratedColumn<String> get aliasesJson => $composableBuilder(
      column: $table.aliasesJson, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EntitiesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntitiesTableTable,
    EntitiesTableData,
    $$EntitiesTableTableFilterComposer,
    $$EntitiesTableTableOrderingComposer,
    $$EntitiesTableTableAnnotationComposer,
    $$EntitiesTableTableCreateCompanionBuilder,
    $$EntitiesTableTableUpdateCompanionBuilder,
    (
      EntitiesTableData,
      BaseReferences<_$AppDatabase, $EntitiesTableTable, EntitiesTableData>
    ),
    EntitiesTableData,
    PrefetchHooks Function()> {
  $$EntitiesTableTableTableManager(_$AppDatabase db, $EntitiesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitiesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitiesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntitiesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> canonicalName = const Value.absent(),
            Value<String> aliasesJson = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntitiesTableCompanion(
            id: id,
            name: name,
            type: type,
            canonicalName: canonicalName,
            aliasesJson: aliasesJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required String canonicalName,
            Value<String> aliasesJson = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EntitiesTableCompanion.insert(
            id: id,
            name: name,
            type: type,
            canonicalName: canonicalName,
            aliasesJson: aliasesJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EntitiesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntitiesTableTable,
    EntitiesTableData,
    $$EntitiesTableTableFilterComposer,
    $$EntitiesTableTableOrderingComposer,
    $$EntitiesTableTableAnnotationComposer,
    $$EntitiesTableTableCreateCompanionBuilder,
    $$EntitiesTableTableUpdateCompanionBuilder,
    (
      EntitiesTableData,
      BaseReferences<_$AppDatabase, $EntitiesTableTable, EntitiesTableData>
    ),
    EntitiesTableData,
    PrefetchHooks Function()>;
typedef $$RelationshipsTableTableCreateCompanionBuilder
    = RelationshipsTableCompanion Function({
  required String id,
  required String sourceEntityId,
  required String relation,
  required String targetEntityId,
  required String sourceMemoryId,
  Value<double> confidence,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$RelationshipsTableTableUpdateCompanionBuilder
    = RelationshipsTableCompanion Function({
  Value<String> id,
  Value<String> sourceEntityId,
  Value<String> relation,
  Value<String> targetEntityId,
  Value<String> sourceMemoryId,
  Value<double> confidence,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$RelationshipsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RelationshipsTableTable> {
  $$RelationshipsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceEntityId => $composableBuilder(
      column: $table.sourceEntityId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relation => $composableBuilder(
      column: $table.relation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetEntityId => $composableBuilder(
      column: $table.targetEntityId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceMemoryId => $composableBuilder(
      column: $table.sourceMemoryId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RelationshipsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RelationshipsTableTable> {
  $$RelationshipsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceEntityId => $composableBuilder(
      column: $table.sourceEntityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relation => $composableBuilder(
      column: $table.relation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetEntityId => $composableBuilder(
      column: $table.targetEntityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceMemoryId => $composableBuilder(
      column: $table.sourceMemoryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RelationshipsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelationshipsTableTable> {
  $$RelationshipsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceEntityId => $composableBuilder(
      column: $table.sourceEntityId, builder: (column) => column);

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  GeneratedColumn<String> get targetEntityId => $composableBuilder(
      column: $table.targetEntityId, builder: (column) => column);

  GeneratedColumn<String> get sourceMemoryId => $composableBuilder(
      column: $table.sourceMemoryId, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RelationshipsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RelationshipsTableTable,
    RelationshipsTableData,
    $$RelationshipsTableTableFilterComposer,
    $$RelationshipsTableTableOrderingComposer,
    $$RelationshipsTableTableAnnotationComposer,
    $$RelationshipsTableTableCreateCompanionBuilder,
    $$RelationshipsTableTableUpdateCompanionBuilder,
    (
      RelationshipsTableData,
      BaseReferences<_$AppDatabase, $RelationshipsTableTable,
          RelationshipsTableData>
    ),
    RelationshipsTableData,
    PrefetchHooks Function()> {
  $$RelationshipsTableTableTableManager(
      _$AppDatabase db, $RelationshipsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationshipsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationshipsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelationshipsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sourceEntityId = const Value.absent(),
            Value<String> relation = const Value.absent(),
            Value<String> targetEntityId = const Value.absent(),
            Value<String> sourceMemoryId = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RelationshipsTableCompanion(
            id: id,
            sourceEntityId: sourceEntityId,
            relation: relation,
            targetEntityId: targetEntityId,
            sourceMemoryId: sourceMemoryId,
            confidence: confidence,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sourceEntityId,
            required String relation,
            required String targetEntityId,
            required String sourceMemoryId,
            Value<double> confidence = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RelationshipsTableCompanion.insert(
            id: id,
            sourceEntityId: sourceEntityId,
            relation: relation,
            targetEntityId: targetEntityId,
            sourceMemoryId: sourceMemoryId,
            confidence: confidence,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RelationshipsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RelationshipsTableTable,
    RelationshipsTableData,
    $$RelationshipsTableTableFilterComposer,
    $$RelationshipsTableTableOrderingComposer,
    $$RelationshipsTableTableAnnotationComposer,
    $$RelationshipsTableTableCreateCompanionBuilder,
    $$RelationshipsTableTableUpdateCompanionBuilder,
    (
      RelationshipsTableData,
      BaseReferences<_$AppDatabase, $RelationshipsTableTable,
          RelationshipsTableData>
    ),
    RelationshipsTableData,
    PrefetchHooks Function()>;
typedef $$TasksTableTableCreateCompanionBuilder = TasksTableCompanion Function({
  required String id,
  required String memoryId,
  required String description,
  Value<String?> dueDate,
  Value<int?> dueTimestamp,
  Value<bool> isCompleted,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$TasksTableTableUpdateCompanionBuilder = TasksTableCompanion Function({
  Value<String> id,
  Value<String> memoryId,
  Value<String> description,
  Value<String?> dueDate,
  Value<int?> dueTimestamp,
  Value<bool> isCompleted,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memoryId => $composableBuilder(
      column: $table.memoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueTimestamp => $composableBuilder(
      column: $table.dueTimestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memoryId => $composableBuilder(
      column: $table.memoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueTimestamp => $composableBuilder(
      column: $table.dueTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get memoryId =>
      $composableBuilder(column: $table.memoryId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get dueTimestamp => $composableBuilder(
      column: $table.dueTimestamp, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TasksTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTableTable,
    TasksTableData,
    $$TasksTableTableFilterComposer,
    $$TasksTableTableOrderingComposer,
    $$TasksTableTableAnnotationComposer,
    $$TasksTableTableCreateCompanionBuilder,
    $$TasksTableTableUpdateCompanionBuilder,
    (
      TasksTableData,
      BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>
    ),
    TasksTableData,
    PrefetchHooks Function()> {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> memoryId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<int?> dueTimestamp = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksTableCompanion(
            id: id,
            memoryId: memoryId,
            description: description,
            dueDate: dueDate,
            dueTimestamp: dueTimestamp,
            isCompleted: isCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String memoryId,
            required String description,
            Value<String?> dueDate = const Value.absent(),
            Value<int?> dueTimestamp = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksTableCompanion.insert(
            id: id,
            memoryId: memoryId,
            description: description,
            dueDate: dueDate,
            dueTimestamp: dueTimestamp,
            isCompleted: isCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTableTable,
    TasksTableData,
    $$TasksTableTableFilterComposer,
    $$TasksTableTableOrderingComposer,
    $$TasksTableTableAnnotationComposer,
    $$TasksTableTableCreateCompanionBuilder,
    $$TasksTableTableUpdateCompanionBuilder,
    (
      TasksTableData,
      BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>
    ),
    TasksTableData,
    PrefetchHooks Function()>;
typedef $$MemoryEntitiesTableTableCreateCompanionBuilder
    = MemoryEntitiesTableCompanion Function({
  required String memoryId,
  required String entityId,
  Value<String> role,
  Value<int> rowid,
});
typedef $$MemoryEntitiesTableTableUpdateCompanionBuilder
    = MemoryEntitiesTableCompanion Function({
  Value<String> memoryId,
  Value<String> entityId,
  Value<String> role,
  Value<int> rowid,
});

class $$MemoryEntitiesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryEntitiesTableTable> {
  $$MemoryEntitiesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get memoryId => $composableBuilder(
      column: $table.memoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));
}

class $$MemoryEntitiesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryEntitiesTableTable> {
  $$MemoryEntitiesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get memoryId => $composableBuilder(
      column: $table.memoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));
}

class $$MemoryEntitiesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryEntitiesTableTable> {
  $$MemoryEntitiesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get memoryId =>
      $composableBuilder(column: $table.memoryId, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$MemoryEntitiesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MemoryEntitiesTableTable,
    MemoryEntitiesTableData,
    $$MemoryEntitiesTableTableFilterComposer,
    $$MemoryEntitiesTableTableOrderingComposer,
    $$MemoryEntitiesTableTableAnnotationComposer,
    $$MemoryEntitiesTableTableCreateCompanionBuilder,
    $$MemoryEntitiesTableTableUpdateCompanionBuilder,
    (
      MemoryEntitiesTableData,
      BaseReferences<_$AppDatabase, $MemoryEntitiesTableTable,
          MemoryEntitiesTableData>
    ),
    MemoryEntitiesTableData,
    PrefetchHooks Function()> {
  $$MemoryEntitiesTableTableTableManager(
      _$AppDatabase db, $MemoryEntitiesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryEntitiesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryEntitiesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryEntitiesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> memoryId = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MemoryEntitiesTableCompanion(
            memoryId: memoryId,
            entityId: entityId,
            role: role,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String memoryId,
            required String entityId,
            Value<String> role = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MemoryEntitiesTableCompanion.insert(
            memoryId: memoryId,
            entityId: entityId,
            role: role,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MemoryEntitiesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MemoryEntitiesTableTable,
    MemoryEntitiesTableData,
    $$MemoryEntitiesTableTableFilterComposer,
    $$MemoryEntitiesTableTableOrderingComposer,
    $$MemoryEntitiesTableTableAnnotationComposer,
    $$MemoryEntitiesTableTableCreateCompanionBuilder,
    $$MemoryEntitiesTableTableUpdateCompanionBuilder,
    (
      MemoryEntitiesTableData,
      BaseReferences<_$AppDatabase, $MemoryEntitiesTableTable,
          MemoryEntitiesTableData>
    ),
    MemoryEntitiesTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db, _db.notesTable);
  $$EmbeddingsTableTableTableManager get embeddingsTable =>
      $$EmbeddingsTableTableTableManager(_db, _db.embeddingsTable);
  $$ClustersTableTableTableManager get clustersTable =>
      $$ClustersTableTableTableManager(_db, _db.clustersTable);
  $$ChatMessagesTableTableTableManager get chatMessagesTable =>
      $$ChatMessagesTableTableTableManager(_db, _db.chatMessagesTable);
  $$EntitiesTableTableTableManager get entitiesTable =>
      $$EntitiesTableTableTableManager(_db, _db.entitiesTable);
  $$RelationshipsTableTableTableManager get relationshipsTable =>
      $$RelationshipsTableTableTableManager(_db, _db.relationshipsTable);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$MemoryEntitiesTableTableTableManager get memoryEntitiesTable =>
      $$MemoryEntitiesTableTableTableManager(_db, _db.memoryEntitiesTable);
}
