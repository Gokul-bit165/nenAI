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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  late final $EmbeddingsTableTable embeddingsTable =
      $EmbeddingsTableTable(this);
  late final $ClustersTableTable clustersTable = $ClustersTableTable(this);
  late final $ChatMessagesTableTable chatMessagesTable =
      $ChatMessagesTableTable(this);
  late final NotesDao notesDao = NotesDao(this as AppDatabase);
  late final EmbeddingsDao embeddingsDao = EmbeddingsDao(this as AppDatabase);
  late final ClustersDao clustersDao = ClustersDao(this as AppDatabase);
  late final ChatMessagesDao chatMessagesDao =
      ChatMessagesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [notesTable, embeddingsTable, clustersTable, chatMessagesTable];
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
}
