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

class $ContextNodesTableTable extends ContextNodesTable
    with TableInfo<$ContextNodesTableTable, ContextNodesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContextNodesTableTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('custom'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _originatingMemoryIdMeta =
      const VerificationMeta('originatingMemoryId');
  @override
  late final GeneratedColumn<String> originatingMemoryId =
      GeneratedColumn<String>('originating_memory_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
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
      [id, name, type, description, originatingMemoryId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'context_nodes';
  @override
  VerificationContext validateIntegrity(
      Insertable<ContextNodesTableData> instance,
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
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('originating_memory_id')) {
      context.handle(
          _originatingMemoryIdMeta,
          originatingMemoryId.isAcceptableOrUnknown(
              data['originating_memory_id']!, _originatingMemoryIdMeta));
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
  ContextNodesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContextNodesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      originatingMemoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}originating_memory_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ContextNodesTableTable createAlias(String alias) {
    return $ContextNodesTableTable(attachedDatabase, alias);
  }
}

class ContextNodesTableData extends DataClass
    implements Insertable<ContextNodesTableData> {
  final String id;
  final String name;

  /// episode, project, topic, activity, task, concept, person, organization, custom
  final String type;
  final String? description;
  final String? originatingMemoryId;
  final int createdAt;
  final int updatedAt;
  const ContextNodesTableData(
      {required this.id,
      required this.name,
      required this.type,
      this.description,
      this.originatingMemoryId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || originatingMemoryId != null) {
      map['originating_memory_id'] = Variable<String>(originatingMemoryId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ContextNodesTableCompanion toCompanion(bool nullToAbsent) {
    return ContextNodesTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      originatingMemoryId: originatingMemoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(originatingMemoryId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ContextNodesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContextNodesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String?>(json['description']),
      originatingMemoryId:
          serializer.fromJson<String?>(json['originatingMemoryId']),
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
      'description': serializer.toJson<String?>(description),
      'originatingMemoryId': serializer.toJson<String?>(originatingMemoryId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ContextNodesTableData copyWith(
          {String? id,
          String? name,
          String? type,
          Value<String?> description = const Value.absent(),
          Value<String?> originatingMemoryId = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      ContextNodesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        description: description.present ? description.value : this.description,
        originatingMemoryId: originatingMemoryId.present
            ? originatingMemoryId.value
            : this.originatingMemoryId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ContextNodesTableData copyWithCompanion(ContextNodesTableCompanion data) {
    return ContextNodesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      description:
          data.description.present ? data.description.value : this.description,
      originatingMemoryId: data.originatingMemoryId.present
          ? data.originatingMemoryId.value
          : this.originatingMemoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContextNodesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('originatingMemoryId: $originatingMemoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, type, description, originatingMemoryId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContextNodesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.description == this.description &&
          other.originatingMemoryId == this.originatingMemoryId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ContextNodesTableCompanion
    extends UpdateCompanion<ContextNodesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> description;
  final Value<String?> originatingMemoryId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ContextNodesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.originatingMemoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContextNodesTableCompanion.insert({
    required String id,
    required String name,
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.originatingMemoryId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ContextNodesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? description,
    Expression<String>? originatingMemoryId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (originatingMemoryId != null)
        'originating_memory_id': originatingMemoryId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContextNodesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String?>? description,
      Value<String?>? originatingMemoryId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return ContextNodesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      originatingMemoryId: originatingMemoryId ?? this.originatingMemoryId,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (originatingMemoryId.present) {
      map['originating_memory_id'] =
          Variable<String>(originatingMemoryId.value);
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
    return (StringBuffer('ContextNodesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('originatingMemoryId: $originatingMemoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContextEdgesTableTable extends ContextEdgesTable
    with TableInfo<$ContextEdgesTableTable, ContextEdgesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContextEdgesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceContextIdMeta =
      const VerificationMeta('sourceContextId');
  @override
  late final GeneratedColumn<String> sourceContextId = GeneratedColumn<String>(
      'source_context_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetContextIdMeta =
      const VerificationMeta('targetContextId');
  @override
  late final GeneratedColumn<String> targetContextId = GeneratedColumn<String>(
      'target_context_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationTypeMeta =
      const VerificationMeta('relationType');
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
      'relation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _originatingMemoryIdMeta =
      const VerificationMeta('originatingMemoryId');
  @override
  late final GeneratedColumn<String> originatingMemoryId =
      GeneratedColumn<String>('originating_memory_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _evidenceMeta =
      const VerificationMeta('evidence');
  @override
  late final GeneratedColumn<String> evidence = GeneratedColumn<String>(
      'evidence', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        sourceContextId,
        targetContextId,
        relationType,
        confidence,
        originatingMemoryId,
        evidence,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'context_edges';
  @override
  VerificationContext validateIntegrity(
      Insertable<ContextEdgesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_context_id')) {
      context.handle(
          _sourceContextIdMeta,
          sourceContextId.isAcceptableOrUnknown(
              data['source_context_id']!, _sourceContextIdMeta));
    } else if (isInserting) {
      context.missing(_sourceContextIdMeta);
    }
    if (data.containsKey('target_context_id')) {
      context.handle(
          _targetContextIdMeta,
          targetContextId.isAcceptableOrUnknown(
              data['target_context_id']!, _targetContextIdMeta));
    } else if (isInserting) {
      context.missing(_targetContextIdMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
          _relationTypeMeta,
          relationType.isAcceptableOrUnknown(
              data['relation_type']!, _relationTypeMeta));
    } else if (isInserting) {
      context.missing(_relationTypeMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('originating_memory_id')) {
      context.handle(
          _originatingMemoryIdMeta,
          originatingMemoryId.isAcceptableOrUnknown(
              data['originating_memory_id']!, _originatingMemoryIdMeta));
    }
    if (data.containsKey('evidence')) {
      context.handle(_evidenceMeta,
          evidence.isAcceptableOrUnknown(data['evidence']!, _evidenceMeta));
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
  ContextEdgesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContextEdgesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceContextId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_context_id'])!,
      targetContextId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_context_id'])!,
      relationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation_type'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      originatingMemoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}originating_memory_id']),
      evidence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evidence']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ContextEdgesTableTable createAlias(String alias) {
    return $ContextEdgesTableTable(attachedDatabase, alias);
  }
}

class ContextEdgesTableData extends DataClass
    implements Insertable<ContextEdgesTableData> {
  final String id;

  /// Parent / Source context node ID
  final String sourceContextId;

  /// Child / Target context node ID
  final String targetContextId;

  /// Semantic relation type: 'part_of', 'sub_topic', 'activity_of', 'outcome_of', 'relates_to'
  final String relationType;

  /// Confidence score between 0.0 and 1.0
  final double confidence;

  /// Provenance: Memory/note ID that originated this relationship
  final String? originatingMemoryId;

  /// Provenance: Snippet or reasoning evidence for this link
  final String? evidence;
  final int createdAt;
  final int updatedAt;
  const ContextEdgesTableData(
      {required this.id,
      required this.sourceContextId,
      required this.targetContextId,
      required this.relationType,
      required this.confidence,
      this.originatingMemoryId,
      this.evidence,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_context_id'] = Variable<String>(sourceContextId);
    map['target_context_id'] = Variable<String>(targetContextId);
    map['relation_type'] = Variable<String>(relationType);
    map['confidence'] = Variable<double>(confidence);
    if (!nullToAbsent || originatingMemoryId != null) {
      map['originating_memory_id'] = Variable<String>(originatingMemoryId);
    }
    if (!nullToAbsent || evidence != null) {
      map['evidence'] = Variable<String>(evidence);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ContextEdgesTableCompanion toCompanion(bool nullToAbsent) {
    return ContextEdgesTableCompanion(
      id: Value(id),
      sourceContextId: Value(sourceContextId),
      targetContextId: Value(targetContextId),
      relationType: Value(relationType),
      confidence: Value(confidence),
      originatingMemoryId: originatingMemoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(originatingMemoryId),
      evidence: evidence == null && nullToAbsent
          ? const Value.absent()
          : Value(evidence),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ContextEdgesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContextEdgesTableData(
      id: serializer.fromJson<String>(json['id']),
      sourceContextId: serializer.fromJson<String>(json['sourceContextId']),
      targetContextId: serializer.fromJson<String>(json['targetContextId']),
      relationType: serializer.fromJson<String>(json['relationType']),
      confidence: serializer.fromJson<double>(json['confidence']),
      originatingMemoryId:
          serializer.fromJson<String?>(json['originatingMemoryId']),
      evidence: serializer.fromJson<String?>(json['evidence']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceContextId': serializer.toJson<String>(sourceContextId),
      'targetContextId': serializer.toJson<String>(targetContextId),
      'relationType': serializer.toJson<String>(relationType),
      'confidence': serializer.toJson<double>(confidence),
      'originatingMemoryId': serializer.toJson<String?>(originatingMemoryId),
      'evidence': serializer.toJson<String?>(evidence),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ContextEdgesTableData copyWith(
          {String? id,
          String? sourceContextId,
          String? targetContextId,
          String? relationType,
          double? confidence,
          Value<String?> originatingMemoryId = const Value.absent(),
          Value<String?> evidence = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      ContextEdgesTableData(
        id: id ?? this.id,
        sourceContextId: sourceContextId ?? this.sourceContextId,
        targetContextId: targetContextId ?? this.targetContextId,
        relationType: relationType ?? this.relationType,
        confidence: confidence ?? this.confidence,
        originatingMemoryId: originatingMemoryId.present
            ? originatingMemoryId.value
            : this.originatingMemoryId,
        evidence: evidence.present ? evidence.value : this.evidence,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ContextEdgesTableData copyWithCompanion(ContextEdgesTableCompanion data) {
    return ContextEdgesTableData(
      id: data.id.present ? data.id.value : this.id,
      sourceContextId: data.sourceContextId.present
          ? data.sourceContextId.value
          : this.sourceContextId,
      targetContextId: data.targetContextId.present
          ? data.targetContextId.value
          : this.targetContextId,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      originatingMemoryId: data.originatingMemoryId.present
          ? data.originatingMemoryId.value
          : this.originatingMemoryId,
      evidence: data.evidence.present ? data.evidence.value : this.evidence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContextEdgesTableData(')
          ..write('id: $id, ')
          ..write('sourceContextId: $sourceContextId, ')
          ..write('targetContextId: $targetContextId, ')
          ..write('relationType: $relationType, ')
          ..write('confidence: $confidence, ')
          ..write('originatingMemoryId: $originatingMemoryId, ')
          ..write('evidence: $evidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sourceContextId,
      targetContextId,
      relationType,
      confidence,
      originatingMemoryId,
      evidence,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContextEdgesTableData &&
          other.id == this.id &&
          other.sourceContextId == this.sourceContextId &&
          other.targetContextId == this.targetContextId &&
          other.relationType == this.relationType &&
          other.confidence == this.confidence &&
          other.originatingMemoryId == this.originatingMemoryId &&
          other.evidence == this.evidence &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ContextEdgesTableCompanion
    extends UpdateCompanion<ContextEdgesTableData> {
  final Value<String> id;
  final Value<String> sourceContextId;
  final Value<String> targetContextId;
  final Value<String> relationType;
  final Value<double> confidence;
  final Value<String?> originatingMemoryId;
  final Value<String?> evidence;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ContextEdgesTableCompanion({
    this.id = const Value.absent(),
    this.sourceContextId = const Value.absent(),
    this.targetContextId = const Value.absent(),
    this.relationType = const Value.absent(),
    this.confidence = const Value.absent(),
    this.originatingMemoryId = const Value.absent(),
    this.evidence = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContextEdgesTableCompanion.insert({
    required String id,
    required String sourceContextId,
    required String targetContextId,
    required String relationType,
    this.confidence = const Value.absent(),
    this.originatingMemoryId = const Value.absent(),
    this.evidence = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceContextId = Value(sourceContextId),
        targetContextId = Value(targetContextId),
        relationType = Value(relationType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ContextEdgesTableData> custom({
    Expression<String>? id,
    Expression<String>? sourceContextId,
    Expression<String>? targetContextId,
    Expression<String>? relationType,
    Expression<double>? confidence,
    Expression<String>? originatingMemoryId,
    Expression<String>? evidence,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceContextId != null) 'source_context_id': sourceContextId,
      if (targetContextId != null) 'target_context_id': targetContextId,
      if (relationType != null) 'relation_type': relationType,
      if (confidence != null) 'confidence': confidence,
      if (originatingMemoryId != null)
        'originating_memory_id': originatingMemoryId,
      if (evidence != null) 'evidence': evidence,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContextEdgesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? sourceContextId,
      Value<String>? targetContextId,
      Value<String>? relationType,
      Value<double>? confidence,
      Value<String?>? originatingMemoryId,
      Value<String?>? evidence,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return ContextEdgesTableCompanion(
      id: id ?? this.id,
      sourceContextId: sourceContextId ?? this.sourceContextId,
      targetContextId: targetContextId ?? this.targetContextId,
      relationType: relationType ?? this.relationType,
      confidence: confidence ?? this.confidence,
      originatingMemoryId: originatingMemoryId ?? this.originatingMemoryId,
      evidence: evidence ?? this.evidence,
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
    if (sourceContextId.present) {
      map['source_context_id'] = Variable<String>(sourceContextId.value);
    }
    if (targetContextId.present) {
      map['target_context_id'] = Variable<String>(targetContextId.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (originatingMemoryId.present) {
      map['originating_memory_id'] =
          Variable<String>(originatingMemoryId.value);
    }
    if (evidence.present) {
      map['evidence'] = Variable<String>(evidence.value);
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
    return (StringBuffer('ContextEdgesTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceContextId: $sourceContextId, ')
          ..write('targetContextId: $targetContextId, ')
          ..write('relationType: $relationType, ')
          ..write('confidence: $confidence, ')
          ..write('originatingMemoryId: $originatingMemoryId, ')
          ..write('evidence: $evidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryContextsTableTable extends MemoryContextsTable
    with TableInfo<$MemoryContextsTableTable, MemoryContextsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryContextsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _memoryIdMeta =
      const VerificationMeta('memoryId');
  @override
  late final GeneratedColumn<String> memoryId = GeneratedColumn<String>(
      'memory_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contextIdMeta =
      const VerificationMeta('contextId');
  @override
  late final GeneratedColumn<String> contextId = GeneratedColumn<String>(
      'context_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('contained_in'));
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _evidenceMeta =
      const VerificationMeta('evidence');
  @override
  late final GeneratedColumn<String> evidence = GeneratedColumn<String>(
      'evidence', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [memoryId, contextId, role, confidence, evidence, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_contexts';
  @override
  VerificationContext validateIntegrity(
      Insertable<MemoryContextsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('memory_id')) {
      context.handle(_memoryIdMeta,
          memoryId.isAcceptableOrUnknown(data['memory_id']!, _memoryIdMeta));
    } else if (isInserting) {
      context.missing(_memoryIdMeta);
    }
    if (data.containsKey('context_id')) {
      context.handle(_contextIdMeta,
          contextId.isAcceptableOrUnknown(data['context_id']!, _contextIdMeta));
    } else if (isInserting) {
      context.missing(_contextIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('evidence')) {
      context.handle(_evidenceMeta,
          evidence.isAcceptableOrUnknown(data['evidence']!, _evidenceMeta));
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
  Set<GeneratedColumn> get $primaryKey => {memoryId, contextId};
  @override
  MemoryContextsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryContextsTableData(
      memoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memory_id'])!,
      contextId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      evidence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evidence']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MemoryContextsTableTable createAlias(String alias) {
    return $MemoryContextsTableTable(attachedDatabase, alias);
  }
}

class MemoryContextsTableData extends DataClass
    implements Insertable<MemoryContextsTableData> {
  final String memoryId;
  final String contextId;

  /// Role of the memory in this context: 'contained_in', 'mentions', 'produced_by', 'evidence_for'
  final String role;

  /// Confidence score between 0.0 and 1.0
  final double confidence;

  /// Provenance: Extracted reasoning or snippet supporting the link
  final String? evidence;
  final int createdAt;
  const MemoryContextsTableData(
      {required this.memoryId,
      required this.contextId,
      required this.role,
      required this.confidence,
      this.evidence,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['memory_id'] = Variable<String>(memoryId);
    map['context_id'] = Variable<String>(contextId);
    map['role'] = Variable<String>(role);
    map['confidence'] = Variable<double>(confidence);
    if (!nullToAbsent || evidence != null) {
      map['evidence'] = Variable<String>(evidence);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  MemoryContextsTableCompanion toCompanion(bool nullToAbsent) {
    return MemoryContextsTableCompanion(
      memoryId: Value(memoryId),
      contextId: Value(contextId),
      role: Value(role),
      confidence: Value(confidence),
      evidence: evidence == null && nullToAbsent
          ? const Value.absent()
          : Value(evidence),
      createdAt: Value(createdAt),
    );
  }

  factory MemoryContextsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryContextsTableData(
      memoryId: serializer.fromJson<String>(json['memoryId']),
      contextId: serializer.fromJson<String>(json['contextId']),
      role: serializer.fromJson<String>(json['role']),
      confidence: serializer.fromJson<double>(json['confidence']),
      evidence: serializer.fromJson<String?>(json['evidence']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'memoryId': serializer.toJson<String>(memoryId),
      'contextId': serializer.toJson<String>(contextId),
      'role': serializer.toJson<String>(role),
      'confidence': serializer.toJson<double>(confidence),
      'evidence': serializer.toJson<String?>(evidence),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  MemoryContextsTableData copyWith(
          {String? memoryId,
          String? contextId,
          String? role,
          double? confidence,
          Value<String?> evidence = const Value.absent(),
          int? createdAt}) =>
      MemoryContextsTableData(
        memoryId: memoryId ?? this.memoryId,
        contextId: contextId ?? this.contextId,
        role: role ?? this.role,
        confidence: confidence ?? this.confidence,
        evidence: evidence.present ? evidence.value : this.evidence,
        createdAt: createdAt ?? this.createdAt,
      );
  MemoryContextsTableData copyWithCompanion(MemoryContextsTableCompanion data) {
    return MemoryContextsTableData(
      memoryId: data.memoryId.present ? data.memoryId.value : this.memoryId,
      contextId: data.contextId.present ? data.contextId.value : this.contextId,
      role: data.role.present ? data.role.value : this.role,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      evidence: data.evidence.present ? data.evidence.value : this.evidence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryContextsTableData(')
          ..write('memoryId: $memoryId, ')
          ..write('contextId: $contextId, ')
          ..write('role: $role, ')
          ..write('confidence: $confidence, ')
          ..write('evidence: $evidence, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(memoryId, contextId, role, confidence, evidence, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryContextsTableData &&
          other.memoryId == this.memoryId &&
          other.contextId == this.contextId &&
          other.role == this.role &&
          other.confidence == this.confidence &&
          other.evidence == this.evidence &&
          other.createdAt == this.createdAt);
}

class MemoryContextsTableCompanion
    extends UpdateCompanion<MemoryContextsTableData> {
  final Value<String> memoryId;
  final Value<String> contextId;
  final Value<String> role;
  final Value<double> confidence;
  final Value<String?> evidence;
  final Value<int> createdAt;
  final Value<int> rowid;
  const MemoryContextsTableCompanion({
    this.memoryId = const Value.absent(),
    this.contextId = const Value.absent(),
    this.role = const Value.absent(),
    this.confidence = const Value.absent(),
    this.evidence = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryContextsTableCompanion.insert({
    required String memoryId,
    required String contextId,
    this.role = const Value.absent(),
    this.confidence = const Value.absent(),
    this.evidence = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : memoryId = Value(memoryId),
        contextId = Value(contextId),
        createdAt = Value(createdAt);
  static Insertable<MemoryContextsTableData> custom({
    Expression<String>? memoryId,
    Expression<String>? contextId,
    Expression<String>? role,
    Expression<double>? confidence,
    Expression<String>? evidence,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (memoryId != null) 'memory_id': memoryId,
      if (contextId != null) 'context_id': contextId,
      if (role != null) 'role': role,
      if (confidence != null) 'confidence': confidence,
      if (evidence != null) 'evidence': evidence,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryContextsTableCompanion copyWith(
      {Value<String>? memoryId,
      Value<String>? contextId,
      Value<String>? role,
      Value<double>? confidence,
      Value<String?>? evidence,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return MemoryContextsTableCompanion(
      memoryId: memoryId ?? this.memoryId,
      contextId: contextId ?? this.contextId,
      role: role ?? this.role,
      confidence: confidence ?? this.confidence,
      evidence: evidence ?? this.evidence,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (memoryId.present) {
      map['memory_id'] = Variable<String>(memoryId.value);
    }
    if (contextId.present) {
      map['context_id'] = Variable<String>(contextId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (evidence.present) {
      map['evidence'] = Variable<String>(evidence.value);
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
    return (StringBuffer('MemoryContextsTableCompanion(')
          ..write('memoryId: $memoryId, ')
          ..write('contextId: $contextId, ')
          ..write('role: $role, ')
          ..write('confidence: $confidence, ')
          ..write('evidence: $evidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryEvidenceTableTable extends MemoryEvidenceTable
    with TableInfo<$MemoryEvidenceTableTable, MemoryEvidenceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryEvidenceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMemoryIdMeta =
      const VerificationMeta('sourceMemoryId');
  @override
  late final GeneratedColumn<String> sourceMemoryId = GeneratedColumn<String>(
      'source_memory_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceTextSnippetMeta =
      const VerificationMeta('sourceTextSnippet');
  @override
  late final GeneratedColumn<String> sourceTextSnippet =
      GeneratedColumn<String>('source_text_snippet', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _targetContextIdMeta =
      const VerificationMeta('targetContextId');
  @override
  late final GeneratedColumn<String> targetContextId = GeneratedColumn<String>(
      'target_context_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetContextNameMeta =
      const VerificationMeta('targetContextName');
  @override
  late final GeneratedColumn<String> targetContextName =
      GeneratedColumn<String>('target_context_name', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _relationTypeMeta =
      const VerificationMeta('relationType');
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
      'relation_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('relates_to'));
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _inferenceTypeMeta =
      const VerificationMeta('inferenceType');
  @override
  late final GeneratedColumn<String> inferenceType = GeneratedColumn<String>(
      'inference_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('weakInference'));
  static const VerificationMeta _signalsJsonMeta =
      const VerificationMeta('signalsJson');
  @override
  late final GeneratedColumn<String> signalsJson = GeneratedColumn<String>(
      'signals_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sourceMemoryId,
        sourceTextSnippet,
        targetContextId,
        targetContextName,
        relationType,
        confidence,
        inferenceType,
        signalsJson,
        explanation,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_evidence';
  @override
  VerificationContext validateIntegrity(
      Insertable<MemoryEvidenceTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_memory_id')) {
      context.handle(
          _sourceMemoryIdMeta,
          sourceMemoryId.isAcceptableOrUnknown(
              data['source_memory_id']!, _sourceMemoryIdMeta));
    } else if (isInserting) {
      context.missing(_sourceMemoryIdMeta);
    }
    if (data.containsKey('source_text_snippet')) {
      context.handle(
          _sourceTextSnippetMeta,
          sourceTextSnippet.isAcceptableOrUnknown(
              data['source_text_snippet']!, _sourceTextSnippetMeta));
    }
    if (data.containsKey('target_context_id')) {
      context.handle(
          _targetContextIdMeta,
          targetContextId.isAcceptableOrUnknown(
              data['target_context_id']!, _targetContextIdMeta));
    } else if (isInserting) {
      context.missing(_targetContextIdMeta);
    }
    if (data.containsKey('target_context_name')) {
      context.handle(
          _targetContextNameMeta,
          targetContextName.isAcceptableOrUnknown(
              data['target_context_name']!, _targetContextNameMeta));
    }
    if (data.containsKey('relation_type')) {
      context.handle(
          _relationTypeMeta,
          relationType.isAcceptableOrUnknown(
              data['relation_type']!, _relationTypeMeta));
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('inference_type')) {
      context.handle(
          _inferenceTypeMeta,
          inferenceType.isAcceptableOrUnknown(
              data['inference_type']!, _inferenceTypeMeta));
    }
    if (data.containsKey('signals_json')) {
      context.handle(
          _signalsJsonMeta,
          signalsJson.isAcceptableOrUnknown(
              data['signals_json']!, _signalsJsonMeta));
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
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
  MemoryEvidenceTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryEvidenceTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceMemoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_memory_id'])!,
      sourceTextSnippet: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_text_snippet'])!,
      targetContextId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_context_id'])!,
      targetContextName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_context_name'])!,
      relationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation_type'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      inferenceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inference_type'])!,
      signalsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}signals_json'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MemoryEvidenceTableTable createAlias(String alias) {
    return $MemoryEvidenceTableTable(attachedDatabase, alias);
  }
}

class MemoryEvidenceTableData extends DataClass
    implements Insertable<MemoryEvidenceTableData> {
  final String id;
  final String sourceMemoryId;
  final String sourceTextSnippet;
  final String targetContextId;
  final String targetContextName;
  final String relationType;

  /// Confidence score between 0.0 and 1.0 (ranking signal)
  final double confidence;

  /// 'explicit' | 'strongInference' | 'weakInference' | 'ambiguousInference'
  final String inferenceType;

  /// JSON-encoded array of EvidenceSignal objects
  final String signalsJson;

  /// Concise human-readable explanation
  final String explanation;
  final int createdAt;
  const MemoryEvidenceTableData(
      {required this.id,
      required this.sourceMemoryId,
      required this.sourceTextSnippet,
      required this.targetContextId,
      required this.targetContextName,
      required this.relationType,
      required this.confidence,
      required this.inferenceType,
      required this.signalsJson,
      required this.explanation,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_memory_id'] = Variable<String>(sourceMemoryId);
    map['source_text_snippet'] = Variable<String>(sourceTextSnippet);
    map['target_context_id'] = Variable<String>(targetContextId);
    map['target_context_name'] = Variable<String>(targetContextName);
    map['relation_type'] = Variable<String>(relationType);
    map['confidence'] = Variable<double>(confidence);
    map['inference_type'] = Variable<String>(inferenceType);
    map['signals_json'] = Variable<String>(signalsJson);
    map['explanation'] = Variable<String>(explanation);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  MemoryEvidenceTableCompanion toCompanion(bool nullToAbsent) {
    return MemoryEvidenceTableCompanion(
      id: Value(id),
      sourceMemoryId: Value(sourceMemoryId),
      sourceTextSnippet: Value(sourceTextSnippet),
      targetContextId: Value(targetContextId),
      targetContextName: Value(targetContextName),
      relationType: Value(relationType),
      confidence: Value(confidence),
      inferenceType: Value(inferenceType),
      signalsJson: Value(signalsJson),
      explanation: Value(explanation),
      createdAt: Value(createdAt),
    );
  }

  factory MemoryEvidenceTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryEvidenceTableData(
      id: serializer.fromJson<String>(json['id']),
      sourceMemoryId: serializer.fromJson<String>(json['sourceMemoryId']),
      sourceTextSnippet: serializer.fromJson<String>(json['sourceTextSnippet']),
      targetContextId: serializer.fromJson<String>(json['targetContextId']),
      targetContextName: serializer.fromJson<String>(json['targetContextName']),
      relationType: serializer.fromJson<String>(json['relationType']),
      confidence: serializer.fromJson<double>(json['confidence']),
      inferenceType: serializer.fromJson<String>(json['inferenceType']),
      signalsJson: serializer.fromJson<String>(json['signalsJson']),
      explanation: serializer.fromJson<String>(json['explanation']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceMemoryId': serializer.toJson<String>(sourceMemoryId),
      'sourceTextSnippet': serializer.toJson<String>(sourceTextSnippet),
      'targetContextId': serializer.toJson<String>(targetContextId),
      'targetContextName': serializer.toJson<String>(targetContextName),
      'relationType': serializer.toJson<String>(relationType),
      'confidence': serializer.toJson<double>(confidence),
      'inferenceType': serializer.toJson<String>(inferenceType),
      'signalsJson': serializer.toJson<String>(signalsJson),
      'explanation': serializer.toJson<String>(explanation),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  MemoryEvidenceTableData copyWith(
          {String? id,
          String? sourceMemoryId,
          String? sourceTextSnippet,
          String? targetContextId,
          String? targetContextName,
          String? relationType,
          double? confidence,
          String? inferenceType,
          String? signalsJson,
          String? explanation,
          int? createdAt}) =>
      MemoryEvidenceTableData(
        id: id ?? this.id,
        sourceMemoryId: sourceMemoryId ?? this.sourceMemoryId,
        sourceTextSnippet: sourceTextSnippet ?? this.sourceTextSnippet,
        targetContextId: targetContextId ?? this.targetContextId,
        targetContextName: targetContextName ?? this.targetContextName,
        relationType: relationType ?? this.relationType,
        confidence: confidence ?? this.confidence,
        inferenceType: inferenceType ?? this.inferenceType,
        signalsJson: signalsJson ?? this.signalsJson,
        explanation: explanation ?? this.explanation,
        createdAt: createdAt ?? this.createdAt,
      );
  MemoryEvidenceTableData copyWithCompanion(MemoryEvidenceTableCompanion data) {
    return MemoryEvidenceTableData(
      id: data.id.present ? data.id.value : this.id,
      sourceMemoryId: data.sourceMemoryId.present
          ? data.sourceMemoryId.value
          : this.sourceMemoryId,
      sourceTextSnippet: data.sourceTextSnippet.present
          ? data.sourceTextSnippet.value
          : this.sourceTextSnippet,
      targetContextId: data.targetContextId.present
          ? data.targetContextId.value
          : this.targetContextId,
      targetContextName: data.targetContextName.present
          ? data.targetContextName.value
          : this.targetContextName,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      inferenceType: data.inferenceType.present
          ? data.inferenceType.value
          : this.inferenceType,
      signalsJson:
          data.signalsJson.present ? data.signalsJson.value : this.signalsJson,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEvidenceTableData(')
          ..write('id: $id, ')
          ..write('sourceMemoryId: $sourceMemoryId, ')
          ..write('sourceTextSnippet: $sourceTextSnippet, ')
          ..write('targetContextId: $targetContextId, ')
          ..write('targetContextName: $targetContextName, ')
          ..write('relationType: $relationType, ')
          ..write('confidence: $confidence, ')
          ..write('inferenceType: $inferenceType, ')
          ..write('signalsJson: $signalsJson, ')
          ..write('explanation: $explanation, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sourceMemoryId,
      sourceTextSnippet,
      targetContextId,
      targetContextName,
      relationType,
      confidence,
      inferenceType,
      signalsJson,
      explanation,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryEvidenceTableData &&
          other.id == this.id &&
          other.sourceMemoryId == this.sourceMemoryId &&
          other.sourceTextSnippet == this.sourceTextSnippet &&
          other.targetContextId == this.targetContextId &&
          other.targetContextName == this.targetContextName &&
          other.relationType == this.relationType &&
          other.confidence == this.confidence &&
          other.inferenceType == this.inferenceType &&
          other.signalsJson == this.signalsJson &&
          other.explanation == this.explanation &&
          other.createdAt == this.createdAt);
}

class MemoryEvidenceTableCompanion
    extends UpdateCompanion<MemoryEvidenceTableData> {
  final Value<String> id;
  final Value<String> sourceMemoryId;
  final Value<String> sourceTextSnippet;
  final Value<String> targetContextId;
  final Value<String> targetContextName;
  final Value<String> relationType;
  final Value<double> confidence;
  final Value<String> inferenceType;
  final Value<String> signalsJson;
  final Value<String> explanation;
  final Value<int> createdAt;
  final Value<int> rowid;
  const MemoryEvidenceTableCompanion({
    this.id = const Value.absent(),
    this.sourceMemoryId = const Value.absent(),
    this.sourceTextSnippet = const Value.absent(),
    this.targetContextId = const Value.absent(),
    this.targetContextName = const Value.absent(),
    this.relationType = const Value.absent(),
    this.confidence = const Value.absent(),
    this.inferenceType = const Value.absent(),
    this.signalsJson = const Value.absent(),
    this.explanation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryEvidenceTableCompanion.insert({
    required String id,
    required String sourceMemoryId,
    this.sourceTextSnippet = const Value.absent(),
    required String targetContextId,
    this.targetContextName = const Value.absent(),
    this.relationType = const Value.absent(),
    this.confidence = const Value.absent(),
    this.inferenceType = const Value.absent(),
    this.signalsJson = const Value.absent(),
    this.explanation = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceMemoryId = Value(sourceMemoryId),
        targetContextId = Value(targetContextId),
        createdAt = Value(createdAt);
  static Insertable<MemoryEvidenceTableData> custom({
    Expression<String>? id,
    Expression<String>? sourceMemoryId,
    Expression<String>? sourceTextSnippet,
    Expression<String>? targetContextId,
    Expression<String>? targetContextName,
    Expression<String>? relationType,
    Expression<double>? confidence,
    Expression<String>? inferenceType,
    Expression<String>? signalsJson,
    Expression<String>? explanation,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceMemoryId != null) 'source_memory_id': sourceMemoryId,
      if (sourceTextSnippet != null) 'source_text_snippet': sourceTextSnippet,
      if (targetContextId != null) 'target_context_id': targetContextId,
      if (targetContextName != null) 'target_context_name': targetContextName,
      if (relationType != null) 'relation_type': relationType,
      if (confidence != null) 'confidence': confidence,
      if (inferenceType != null) 'inference_type': inferenceType,
      if (signalsJson != null) 'signals_json': signalsJson,
      if (explanation != null) 'explanation': explanation,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryEvidenceTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? sourceMemoryId,
      Value<String>? sourceTextSnippet,
      Value<String>? targetContextId,
      Value<String>? targetContextName,
      Value<String>? relationType,
      Value<double>? confidence,
      Value<String>? inferenceType,
      Value<String>? signalsJson,
      Value<String>? explanation,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return MemoryEvidenceTableCompanion(
      id: id ?? this.id,
      sourceMemoryId: sourceMemoryId ?? this.sourceMemoryId,
      sourceTextSnippet: sourceTextSnippet ?? this.sourceTextSnippet,
      targetContextId: targetContextId ?? this.targetContextId,
      targetContextName: targetContextName ?? this.targetContextName,
      relationType: relationType ?? this.relationType,
      confidence: confidence ?? this.confidence,
      inferenceType: inferenceType ?? this.inferenceType,
      signalsJson: signalsJson ?? this.signalsJson,
      explanation: explanation ?? this.explanation,
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
    if (sourceMemoryId.present) {
      map['source_memory_id'] = Variable<String>(sourceMemoryId.value);
    }
    if (sourceTextSnippet.present) {
      map['source_text_snippet'] = Variable<String>(sourceTextSnippet.value);
    }
    if (targetContextId.present) {
      map['target_context_id'] = Variable<String>(targetContextId.value);
    }
    if (targetContextName.present) {
      map['target_context_name'] = Variable<String>(targetContextName.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (inferenceType.present) {
      map['inference_type'] = Variable<String>(inferenceType.value);
    }
    if (signalsJson.present) {
      map['signals_json'] = Variable<String>(signalsJson.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
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
    return (StringBuffer('MemoryEvidenceTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceMemoryId: $sourceMemoryId, ')
          ..write('sourceTextSnippet: $sourceTextSnippet, ')
          ..write('targetContextId: $targetContextId, ')
          ..write('targetContextName: $targetContextName, ')
          ..write('relationType: $relationType, ')
          ..write('confidence: $confidence, ')
          ..write('inferenceType: $inferenceType, ')
          ..write('signalsJson: $signalsJson, ')
          ..write('explanation: $explanation, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingResolutionsTableTable extends PendingResolutionsTable
    with TableInfo<$PendingResolutionsTableTable, PendingResolutionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingResolutionsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _noteTextSnippetMeta =
      const VerificationMeta('noteTextSnippet');
  @override
  late final GeneratedColumn<String> noteTextSnippet = GeneratedColumn<String>(
      'note_text_snippet', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _candidatesJsonMeta =
      const VerificationMeta('candidatesJson');
  @override
  late final GeneratedColumn<String> candidatesJson = GeneratedColumn<String>(
      'candidates_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _selectedContextIdMeta =
      const VerificationMeta('selectedContextId');
  @override
  late final GeneratedColumn<String> selectedContextId =
      GeneratedColumn<String>('selected_context_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resolutionSourceMeta =
      const VerificationMeta('resolutionSource');
  @override
  late final GeneratedColumn<String> resolutionSource = GeneratedColumn<String>(
      'resolution_source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _resolvedAtMeta =
      const VerificationMeta('resolvedAt');
  @override
  late final GeneratedColumn<int> resolvedAt = GeneratedColumn<int>(
      'resolved_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        memoryId,
        noteTextSnippet,
        candidatesJson,
        status,
        selectedContextId,
        resolutionSource,
        createdAt,
        resolvedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_resolutions';
  @override
  VerificationContext validateIntegrity(
      Insertable<PendingResolutionsTableData> instance,
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
    if (data.containsKey('note_text_snippet')) {
      context.handle(
          _noteTextSnippetMeta,
          noteTextSnippet.isAcceptableOrUnknown(
              data['note_text_snippet']!, _noteTextSnippetMeta));
    }
    if (data.containsKey('candidates_json')) {
      context.handle(
          _candidatesJsonMeta,
          candidatesJson.isAcceptableOrUnknown(
              data['candidates_json']!, _candidatesJsonMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('selected_context_id')) {
      context.handle(
          _selectedContextIdMeta,
          selectedContextId.isAcceptableOrUnknown(
              data['selected_context_id']!, _selectedContextIdMeta));
    }
    if (data.containsKey('resolution_source')) {
      context.handle(
          _resolutionSourceMeta,
          resolutionSource.isAcceptableOrUnknown(
              data['resolution_source']!, _resolutionSourceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
          _resolvedAtMeta,
          resolvedAt.isAcceptableOrUnknown(
              data['resolved_at']!, _resolvedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingResolutionsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingResolutionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      memoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memory_id'])!,
      noteTextSnippet: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}note_text_snippet'])!,
      candidatesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}candidates_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      selectedContextId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}selected_context_id']),
      resolutionSource: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}resolution_source']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      resolvedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}resolved_at']),
    );
  }

  @override
  $PendingResolutionsTableTable createAlias(String alias) {
    return $PendingResolutionsTableTable(attachedDatabase, alias);
  }
}

class PendingResolutionsTableData extends DataClass
    implements Insertable<PendingResolutionsTableData> {
  final String id;
  final String memoryId;
  final String noteTextSnippet;

  /// JSON-encoded array of ResolutionCandidateOption
  final String candidatesJson;

  /// 'pending', 'resolved', 'dismissed'
  final String status;
  final String? selectedContextId;

  /// 'automatic', 'user_confirmed', 'user_rejected', 'manual'
  final String? resolutionSource;
  final int createdAt;
  final int? resolvedAt;
  const PendingResolutionsTableData(
      {required this.id,
      required this.memoryId,
      required this.noteTextSnippet,
      required this.candidatesJson,
      required this.status,
      this.selectedContextId,
      this.resolutionSource,
      required this.createdAt,
      this.resolvedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['memory_id'] = Variable<String>(memoryId);
    map['note_text_snippet'] = Variable<String>(noteTextSnippet);
    map['candidates_json'] = Variable<String>(candidatesJson);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || selectedContextId != null) {
      map['selected_context_id'] = Variable<String>(selectedContextId);
    }
    if (!nullToAbsent || resolutionSource != null) {
      map['resolution_source'] = Variable<String>(resolutionSource);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<int>(resolvedAt);
    }
    return map;
  }

  PendingResolutionsTableCompanion toCompanion(bool nullToAbsent) {
    return PendingResolutionsTableCompanion(
      id: Value(id),
      memoryId: Value(memoryId),
      noteTextSnippet: Value(noteTextSnippet),
      candidatesJson: Value(candidatesJson),
      status: Value(status),
      selectedContextId: selectedContextId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedContextId),
      resolutionSource: resolutionSource == null && nullToAbsent
          ? const Value.absent()
          : Value(resolutionSource),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory PendingResolutionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingResolutionsTableData(
      id: serializer.fromJson<String>(json['id']),
      memoryId: serializer.fromJson<String>(json['memoryId']),
      noteTextSnippet: serializer.fromJson<String>(json['noteTextSnippet']),
      candidatesJson: serializer.fromJson<String>(json['candidatesJson']),
      status: serializer.fromJson<String>(json['status']),
      selectedContextId:
          serializer.fromJson<String?>(json['selectedContextId']),
      resolutionSource: serializer.fromJson<String?>(json['resolutionSource']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      resolvedAt: serializer.fromJson<int?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memoryId': serializer.toJson<String>(memoryId),
      'noteTextSnippet': serializer.toJson<String>(noteTextSnippet),
      'candidatesJson': serializer.toJson<String>(candidatesJson),
      'status': serializer.toJson<String>(status),
      'selectedContextId': serializer.toJson<String?>(selectedContextId),
      'resolutionSource': serializer.toJson<String?>(resolutionSource),
      'createdAt': serializer.toJson<int>(createdAt),
      'resolvedAt': serializer.toJson<int?>(resolvedAt),
    };
  }

  PendingResolutionsTableData copyWith(
          {String? id,
          String? memoryId,
          String? noteTextSnippet,
          String? candidatesJson,
          String? status,
          Value<String?> selectedContextId = const Value.absent(),
          Value<String?> resolutionSource = const Value.absent(),
          int? createdAt,
          Value<int?> resolvedAt = const Value.absent()}) =>
      PendingResolutionsTableData(
        id: id ?? this.id,
        memoryId: memoryId ?? this.memoryId,
        noteTextSnippet: noteTextSnippet ?? this.noteTextSnippet,
        candidatesJson: candidatesJson ?? this.candidatesJson,
        status: status ?? this.status,
        selectedContextId: selectedContextId.present
            ? selectedContextId.value
            : this.selectedContextId,
        resolutionSource: resolutionSource.present
            ? resolutionSource.value
            : this.resolutionSource,
        createdAt: createdAt ?? this.createdAt,
        resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
      );
  PendingResolutionsTableData copyWithCompanion(
      PendingResolutionsTableCompanion data) {
    return PendingResolutionsTableData(
      id: data.id.present ? data.id.value : this.id,
      memoryId: data.memoryId.present ? data.memoryId.value : this.memoryId,
      noteTextSnippet: data.noteTextSnippet.present
          ? data.noteTextSnippet.value
          : this.noteTextSnippet,
      candidatesJson: data.candidatesJson.present
          ? data.candidatesJson.value
          : this.candidatesJson,
      status: data.status.present ? data.status.value : this.status,
      selectedContextId: data.selectedContextId.present
          ? data.selectedContextId.value
          : this.selectedContextId,
      resolutionSource: data.resolutionSource.present
          ? data.resolutionSource.value
          : this.resolutionSource,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt:
          data.resolvedAt.present ? data.resolvedAt.value : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingResolutionsTableData(')
          ..write('id: $id, ')
          ..write('memoryId: $memoryId, ')
          ..write('noteTextSnippet: $noteTextSnippet, ')
          ..write('candidatesJson: $candidatesJson, ')
          ..write('status: $status, ')
          ..write('selectedContextId: $selectedContextId, ')
          ..write('resolutionSource: $resolutionSource, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, memoryId, noteTextSnippet, candidatesJson,
      status, selectedContextId, resolutionSource, createdAt, resolvedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingResolutionsTableData &&
          other.id == this.id &&
          other.memoryId == this.memoryId &&
          other.noteTextSnippet == this.noteTextSnippet &&
          other.candidatesJson == this.candidatesJson &&
          other.status == this.status &&
          other.selectedContextId == this.selectedContextId &&
          other.resolutionSource == this.resolutionSource &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt);
}

class PendingResolutionsTableCompanion
    extends UpdateCompanion<PendingResolutionsTableData> {
  final Value<String> id;
  final Value<String> memoryId;
  final Value<String> noteTextSnippet;
  final Value<String> candidatesJson;
  final Value<String> status;
  final Value<String?> selectedContextId;
  final Value<String?> resolutionSource;
  final Value<int> createdAt;
  final Value<int?> resolvedAt;
  final Value<int> rowid;
  const PendingResolutionsTableCompanion({
    this.id = const Value.absent(),
    this.memoryId = const Value.absent(),
    this.noteTextSnippet = const Value.absent(),
    this.candidatesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.selectedContextId = const Value.absent(),
    this.resolutionSource = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingResolutionsTableCompanion.insert({
    required String id,
    required String memoryId,
    this.noteTextSnippet = const Value.absent(),
    this.candidatesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.selectedContextId = const Value.absent(),
    this.resolutionSource = const Value.absent(),
    required int createdAt,
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        memoryId = Value(memoryId),
        createdAt = Value(createdAt);
  static Insertable<PendingResolutionsTableData> custom({
    Expression<String>? id,
    Expression<String>? memoryId,
    Expression<String>? noteTextSnippet,
    Expression<String>? candidatesJson,
    Expression<String>? status,
    Expression<String>? selectedContextId,
    Expression<String>? resolutionSource,
    Expression<int>? createdAt,
    Expression<int>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memoryId != null) 'memory_id': memoryId,
      if (noteTextSnippet != null) 'note_text_snippet': noteTextSnippet,
      if (candidatesJson != null) 'candidates_json': candidatesJson,
      if (status != null) 'status': status,
      if (selectedContextId != null) 'selected_context_id': selectedContextId,
      if (resolutionSource != null) 'resolution_source': resolutionSource,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingResolutionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? memoryId,
      Value<String>? noteTextSnippet,
      Value<String>? candidatesJson,
      Value<String>? status,
      Value<String?>? selectedContextId,
      Value<String?>? resolutionSource,
      Value<int>? createdAt,
      Value<int?>? resolvedAt,
      Value<int>? rowid}) {
    return PendingResolutionsTableCompanion(
      id: id ?? this.id,
      memoryId: memoryId ?? this.memoryId,
      noteTextSnippet: noteTextSnippet ?? this.noteTextSnippet,
      candidatesJson: candidatesJson ?? this.candidatesJson,
      status: status ?? this.status,
      selectedContextId: selectedContextId ?? this.selectedContextId,
      resolutionSource: resolutionSource ?? this.resolutionSource,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
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
    if (noteTextSnippet.present) {
      map['note_text_snippet'] = Variable<String>(noteTextSnippet.value);
    }
    if (candidatesJson.present) {
      map['candidates_json'] = Variable<String>(candidatesJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (selectedContextId.present) {
      map['selected_context_id'] = Variable<String>(selectedContextId.value);
    }
    if (resolutionSource.present) {
      map['resolution_source'] = Variable<String>(resolutionSource.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<int>(resolvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingResolutionsTableCompanion(')
          ..write('id: $id, ')
          ..write('memoryId: $memoryId, ')
          ..write('noteTextSnippet: $noteTextSnippet, ')
          ..write('candidatesJson: $candidatesJson, ')
          ..write('status: $status, ')
          ..write('selectedContextId: $selectedContextId, ')
          ..write('resolutionSource: $resolutionSource, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
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
  late final $ContextNodesTableTable contextNodesTable =
      $ContextNodesTableTable(this);
  late final $ContextEdgesTableTable contextEdgesTable =
      $ContextEdgesTableTable(this);
  late final $MemoryContextsTableTable memoryContextsTable =
      $MemoryContextsTableTable(this);
  late final $MemoryEvidenceTableTable memoryEvidenceTable =
      $MemoryEvidenceTableTable(this);
  late final $PendingResolutionsTableTable pendingResolutionsTable =
      $PendingResolutionsTableTable(this);
  late final NotesDao notesDao = NotesDao(this as AppDatabase);
  late final EmbeddingsDao embeddingsDao = EmbeddingsDao(this as AppDatabase);
  late final ClustersDao clustersDao = ClustersDao(this as AppDatabase);
  late final ChatMessagesDao chatMessagesDao =
      ChatMessagesDao(this as AppDatabase);
  late final EntitiesDao entitiesDao = EntitiesDao(this as AppDatabase);
  late final RelationshipsDao relationshipsDao =
      RelationshipsDao(this as AppDatabase);
  late final TasksDao tasksDao = TasksDao(this as AppDatabase);
  late final ContextDao contextDao = ContextDao(this as AppDatabase);
  late final EvidenceDao evidenceDao = EvidenceDao(this as AppDatabase);
  late final PendingResolutionsDao pendingResolutionsDao =
      PendingResolutionsDao(this as AppDatabase);
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
        memoryEntitiesTable,
        contextNodesTable,
        contextEdgesTable,
        memoryContextsTable,
        memoryEvidenceTable,
        pendingResolutionsTable
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
typedef $$ContextNodesTableTableCreateCompanionBuilder
    = ContextNodesTableCompanion Function({
  required String id,
  required String name,
  Value<String> type,
  Value<String?> description,
  Value<String?> originatingMemoryId,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$ContextNodesTableTableUpdateCompanionBuilder
    = ContextNodesTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String?> description,
  Value<String?> originatingMemoryId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$ContextNodesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ContextNodesTableTable> {
  $$ContextNodesTableTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originatingMemoryId => $composableBuilder(
      column: $table.originatingMemoryId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ContextNodesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ContextNodesTableTable> {
  $$ContextNodesTableTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originatingMemoryId => $composableBuilder(
      column: $table.originatingMemoryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ContextNodesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContextNodesTableTable> {
  $$ContextNodesTableTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get originatingMemoryId => $composableBuilder(
      column: $table.originatingMemoryId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ContextNodesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContextNodesTableTable,
    ContextNodesTableData,
    $$ContextNodesTableTableFilterComposer,
    $$ContextNodesTableTableOrderingComposer,
    $$ContextNodesTableTableAnnotationComposer,
    $$ContextNodesTableTableCreateCompanionBuilder,
    $$ContextNodesTableTableUpdateCompanionBuilder,
    (
      ContextNodesTableData,
      BaseReferences<_$AppDatabase, $ContextNodesTableTable,
          ContextNodesTableData>
    ),
    ContextNodesTableData,
    PrefetchHooks Function()> {
  $$ContextNodesTableTableTableManager(
      _$AppDatabase db, $ContextNodesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContextNodesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContextNodesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContextNodesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> originatingMemoryId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContextNodesTableCompanion(
            id: id,
            name: name,
            type: type,
            description: description,
            originatingMemoryId: originatingMemoryId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> type = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> originatingMemoryId = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ContextNodesTableCompanion.insert(
            id: id,
            name: name,
            type: type,
            description: description,
            originatingMemoryId: originatingMemoryId,
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

typedef $$ContextNodesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContextNodesTableTable,
    ContextNodesTableData,
    $$ContextNodesTableTableFilterComposer,
    $$ContextNodesTableTableOrderingComposer,
    $$ContextNodesTableTableAnnotationComposer,
    $$ContextNodesTableTableCreateCompanionBuilder,
    $$ContextNodesTableTableUpdateCompanionBuilder,
    (
      ContextNodesTableData,
      BaseReferences<_$AppDatabase, $ContextNodesTableTable,
          ContextNodesTableData>
    ),
    ContextNodesTableData,
    PrefetchHooks Function()>;
typedef $$ContextEdgesTableTableCreateCompanionBuilder
    = ContextEdgesTableCompanion Function({
  required String id,
  required String sourceContextId,
  required String targetContextId,
  required String relationType,
  Value<double> confidence,
  Value<String?> originatingMemoryId,
  Value<String?> evidence,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$ContextEdgesTableTableUpdateCompanionBuilder
    = ContextEdgesTableCompanion Function({
  Value<String> id,
  Value<String> sourceContextId,
  Value<String> targetContextId,
  Value<String> relationType,
  Value<double> confidence,
  Value<String?> originatingMemoryId,
  Value<String?> evidence,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$ContextEdgesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ContextEdgesTableTable> {
  $$ContextEdgesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceContextId => $composableBuilder(
      column: $table.sourceContextId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetContextId => $composableBuilder(
      column: $table.targetContextId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originatingMemoryId => $composableBuilder(
      column: $table.originatingMemoryId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evidence => $composableBuilder(
      column: $table.evidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ContextEdgesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ContextEdgesTableTable> {
  $$ContextEdgesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceContextId => $composableBuilder(
      column: $table.sourceContextId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetContextId => $composableBuilder(
      column: $table.targetContextId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationType => $composableBuilder(
      column: $table.relationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originatingMemoryId => $composableBuilder(
      column: $table.originatingMemoryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evidence => $composableBuilder(
      column: $table.evidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ContextEdgesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContextEdgesTableTable> {
  $$ContextEdgesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceContextId => $composableBuilder(
      column: $table.sourceContextId, builder: (column) => column);

  GeneratedColumn<String> get targetContextId => $composableBuilder(
      column: $table.targetContextId, builder: (column) => column);

  GeneratedColumn<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get originatingMemoryId => $composableBuilder(
      column: $table.originatingMemoryId, builder: (column) => column);

  GeneratedColumn<String> get evidence =>
      $composableBuilder(column: $table.evidence, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ContextEdgesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContextEdgesTableTable,
    ContextEdgesTableData,
    $$ContextEdgesTableTableFilterComposer,
    $$ContextEdgesTableTableOrderingComposer,
    $$ContextEdgesTableTableAnnotationComposer,
    $$ContextEdgesTableTableCreateCompanionBuilder,
    $$ContextEdgesTableTableUpdateCompanionBuilder,
    (
      ContextEdgesTableData,
      BaseReferences<_$AppDatabase, $ContextEdgesTableTable,
          ContextEdgesTableData>
    ),
    ContextEdgesTableData,
    PrefetchHooks Function()> {
  $$ContextEdgesTableTableTableManager(
      _$AppDatabase db, $ContextEdgesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContextEdgesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContextEdgesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContextEdgesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sourceContextId = const Value.absent(),
            Value<String> targetContextId = const Value.absent(),
            Value<String> relationType = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String?> originatingMemoryId = const Value.absent(),
            Value<String?> evidence = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContextEdgesTableCompanion(
            id: id,
            sourceContextId: sourceContextId,
            targetContextId: targetContextId,
            relationType: relationType,
            confidence: confidence,
            originatingMemoryId: originatingMemoryId,
            evidence: evidence,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sourceContextId,
            required String targetContextId,
            required String relationType,
            Value<double> confidence = const Value.absent(),
            Value<String?> originatingMemoryId = const Value.absent(),
            Value<String?> evidence = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ContextEdgesTableCompanion.insert(
            id: id,
            sourceContextId: sourceContextId,
            targetContextId: targetContextId,
            relationType: relationType,
            confidence: confidence,
            originatingMemoryId: originatingMemoryId,
            evidence: evidence,
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

typedef $$ContextEdgesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContextEdgesTableTable,
    ContextEdgesTableData,
    $$ContextEdgesTableTableFilterComposer,
    $$ContextEdgesTableTableOrderingComposer,
    $$ContextEdgesTableTableAnnotationComposer,
    $$ContextEdgesTableTableCreateCompanionBuilder,
    $$ContextEdgesTableTableUpdateCompanionBuilder,
    (
      ContextEdgesTableData,
      BaseReferences<_$AppDatabase, $ContextEdgesTableTable,
          ContextEdgesTableData>
    ),
    ContextEdgesTableData,
    PrefetchHooks Function()>;
typedef $$MemoryContextsTableTableCreateCompanionBuilder
    = MemoryContextsTableCompanion Function({
  required String memoryId,
  required String contextId,
  Value<String> role,
  Value<double> confidence,
  Value<String?> evidence,
  required int createdAt,
  Value<int> rowid,
});
typedef $$MemoryContextsTableTableUpdateCompanionBuilder
    = MemoryContextsTableCompanion Function({
  Value<String> memoryId,
  Value<String> contextId,
  Value<String> role,
  Value<double> confidence,
  Value<String?> evidence,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$MemoryContextsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryContextsTableTable> {
  $$MemoryContextsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get memoryId => $composableBuilder(
      column: $table.memoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contextId => $composableBuilder(
      column: $table.contextId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evidence => $composableBuilder(
      column: $table.evidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MemoryContextsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryContextsTableTable> {
  $$MemoryContextsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get memoryId => $composableBuilder(
      column: $table.memoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contextId => $composableBuilder(
      column: $table.contextId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evidence => $composableBuilder(
      column: $table.evidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MemoryContextsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryContextsTableTable> {
  $$MemoryContextsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get memoryId =>
      $composableBuilder(column: $table.memoryId, builder: (column) => column);

  GeneratedColumn<String> get contextId =>
      $composableBuilder(column: $table.contextId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get evidence =>
      $composableBuilder(column: $table.evidence, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MemoryContextsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MemoryContextsTableTable,
    MemoryContextsTableData,
    $$MemoryContextsTableTableFilterComposer,
    $$MemoryContextsTableTableOrderingComposer,
    $$MemoryContextsTableTableAnnotationComposer,
    $$MemoryContextsTableTableCreateCompanionBuilder,
    $$MemoryContextsTableTableUpdateCompanionBuilder,
    (
      MemoryContextsTableData,
      BaseReferences<_$AppDatabase, $MemoryContextsTableTable,
          MemoryContextsTableData>
    ),
    MemoryContextsTableData,
    PrefetchHooks Function()> {
  $$MemoryContextsTableTableTableManager(
      _$AppDatabase db, $MemoryContextsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryContextsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryContextsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryContextsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> memoryId = const Value.absent(),
            Value<String> contextId = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String?> evidence = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MemoryContextsTableCompanion(
            memoryId: memoryId,
            contextId: contextId,
            role: role,
            confidence: confidence,
            evidence: evidence,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String memoryId,
            required String contextId,
            Value<String> role = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String?> evidence = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MemoryContextsTableCompanion.insert(
            memoryId: memoryId,
            contextId: contextId,
            role: role,
            confidence: confidence,
            evidence: evidence,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MemoryContextsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MemoryContextsTableTable,
    MemoryContextsTableData,
    $$MemoryContextsTableTableFilterComposer,
    $$MemoryContextsTableTableOrderingComposer,
    $$MemoryContextsTableTableAnnotationComposer,
    $$MemoryContextsTableTableCreateCompanionBuilder,
    $$MemoryContextsTableTableUpdateCompanionBuilder,
    (
      MemoryContextsTableData,
      BaseReferences<_$AppDatabase, $MemoryContextsTableTable,
          MemoryContextsTableData>
    ),
    MemoryContextsTableData,
    PrefetchHooks Function()>;
typedef $$MemoryEvidenceTableTableCreateCompanionBuilder
    = MemoryEvidenceTableCompanion Function({
  required String id,
  required String sourceMemoryId,
  Value<String> sourceTextSnippet,
  required String targetContextId,
  Value<String> targetContextName,
  Value<String> relationType,
  Value<double> confidence,
  Value<String> inferenceType,
  Value<String> signalsJson,
  Value<String> explanation,
  required int createdAt,
  Value<int> rowid,
});
typedef $$MemoryEvidenceTableTableUpdateCompanionBuilder
    = MemoryEvidenceTableCompanion Function({
  Value<String> id,
  Value<String> sourceMemoryId,
  Value<String> sourceTextSnippet,
  Value<String> targetContextId,
  Value<String> targetContextName,
  Value<String> relationType,
  Value<double> confidence,
  Value<String> inferenceType,
  Value<String> signalsJson,
  Value<String> explanation,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$MemoryEvidenceTableTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryEvidenceTableTable> {
  $$MemoryEvidenceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceMemoryId => $composableBuilder(
      column: $table.sourceMemoryId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceTextSnippet => $composableBuilder(
      column: $table.sourceTextSnippet,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetContextId => $composableBuilder(
      column: $table.targetContextId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetContextName => $composableBuilder(
      column: $table.targetContextName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inferenceType => $composableBuilder(
      column: $table.inferenceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get signalsJson => $composableBuilder(
      column: $table.signalsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MemoryEvidenceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryEvidenceTableTable> {
  $$MemoryEvidenceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceMemoryId => $composableBuilder(
      column: $table.sourceMemoryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceTextSnippet => $composableBuilder(
      column: $table.sourceTextSnippet,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetContextId => $composableBuilder(
      column: $table.targetContextId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetContextName => $composableBuilder(
      column: $table.targetContextName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationType => $composableBuilder(
      column: $table.relationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inferenceType => $composableBuilder(
      column: $table.inferenceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get signalsJson => $composableBuilder(
      column: $table.signalsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MemoryEvidenceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryEvidenceTableTable> {
  $$MemoryEvidenceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceMemoryId => $composableBuilder(
      column: $table.sourceMemoryId, builder: (column) => column);

  GeneratedColumn<String> get sourceTextSnippet => $composableBuilder(
      column: $table.sourceTextSnippet, builder: (column) => column);

  GeneratedColumn<String> get targetContextId => $composableBuilder(
      column: $table.targetContextId, builder: (column) => column);

  GeneratedColumn<String> get targetContextName => $composableBuilder(
      column: $table.targetContextName, builder: (column) => column);

  GeneratedColumn<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get inferenceType => $composableBuilder(
      column: $table.inferenceType, builder: (column) => column);

  GeneratedColumn<String> get signalsJson => $composableBuilder(
      column: $table.signalsJson, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MemoryEvidenceTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MemoryEvidenceTableTable,
    MemoryEvidenceTableData,
    $$MemoryEvidenceTableTableFilterComposer,
    $$MemoryEvidenceTableTableOrderingComposer,
    $$MemoryEvidenceTableTableAnnotationComposer,
    $$MemoryEvidenceTableTableCreateCompanionBuilder,
    $$MemoryEvidenceTableTableUpdateCompanionBuilder,
    (
      MemoryEvidenceTableData,
      BaseReferences<_$AppDatabase, $MemoryEvidenceTableTable,
          MemoryEvidenceTableData>
    ),
    MemoryEvidenceTableData,
    PrefetchHooks Function()> {
  $$MemoryEvidenceTableTableTableManager(
      _$AppDatabase db, $MemoryEvidenceTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryEvidenceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryEvidenceTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryEvidenceTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sourceMemoryId = const Value.absent(),
            Value<String> sourceTextSnippet = const Value.absent(),
            Value<String> targetContextId = const Value.absent(),
            Value<String> targetContextName = const Value.absent(),
            Value<String> relationType = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String> inferenceType = const Value.absent(),
            Value<String> signalsJson = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MemoryEvidenceTableCompanion(
            id: id,
            sourceMemoryId: sourceMemoryId,
            sourceTextSnippet: sourceTextSnippet,
            targetContextId: targetContextId,
            targetContextName: targetContextName,
            relationType: relationType,
            confidence: confidence,
            inferenceType: inferenceType,
            signalsJson: signalsJson,
            explanation: explanation,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sourceMemoryId,
            Value<String> sourceTextSnippet = const Value.absent(),
            required String targetContextId,
            Value<String> targetContextName = const Value.absent(),
            Value<String> relationType = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String> inferenceType = const Value.absent(),
            Value<String> signalsJson = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MemoryEvidenceTableCompanion.insert(
            id: id,
            sourceMemoryId: sourceMemoryId,
            sourceTextSnippet: sourceTextSnippet,
            targetContextId: targetContextId,
            targetContextName: targetContextName,
            relationType: relationType,
            confidence: confidence,
            inferenceType: inferenceType,
            signalsJson: signalsJson,
            explanation: explanation,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MemoryEvidenceTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MemoryEvidenceTableTable,
    MemoryEvidenceTableData,
    $$MemoryEvidenceTableTableFilterComposer,
    $$MemoryEvidenceTableTableOrderingComposer,
    $$MemoryEvidenceTableTableAnnotationComposer,
    $$MemoryEvidenceTableTableCreateCompanionBuilder,
    $$MemoryEvidenceTableTableUpdateCompanionBuilder,
    (
      MemoryEvidenceTableData,
      BaseReferences<_$AppDatabase, $MemoryEvidenceTableTable,
          MemoryEvidenceTableData>
    ),
    MemoryEvidenceTableData,
    PrefetchHooks Function()>;
typedef $$PendingResolutionsTableTableCreateCompanionBuilder
    = PendingResolutionsTableCompanion Function({
  required String id,
  required String memoryId,
  Value<String> noteTextSnippet,
  Value<String> candidatesJson,
  Value<String> status,
  Value<String?> selectedContextId,
  Value<String?> resolutionSource,
  required int createdAt,
  Value<int?> resolvedAt,
  Value<int> rowid,
});
typedef $$PendingResolutionsTableTableUpdateCompanionBuilder
    = PendingResolutionsTableCompanion Function({
  Value<String> id,
  Value<String> memoryId,
  Value<String> noteTextSnippet,
  Value<String> candidatesJson,
  Value<String> status,
  Value<String?> selectedContextId,
  Value<String?> resolutionSource,
  Value<int> createdAt,
  Value<int?> resolvedAt,
  Value<int> rowid,
});

class $$PendingResolutionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingResolutionsTableTable> {
  $$PendingResolutionsTableTableFilterComposer({
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

  ColumnFilters<String> get noteTextSnippet => $composableBuilder(
      column: $table.noteTextSnippet,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get candidatesJson => $composableBuilder(
      column: $table.candidatesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectedContextId => $composableBuilder(
      column: $table.selectedContextId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolutionSource => $composableBuilder(
      column: $table.resolutionSource,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnFilters(column));
}

class $$PendingResolutionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingResolutionsTableTable> {
  $$PendingResolutionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get noteTextSnippet => $composableBuilder(
      column: $table.noteTextSnippet,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get candidatesJson => $composableBuilder(
      column: $table.candidatesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectedContextId => $composableBuilder(
      column: $table.selectedContextId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolutionSource => $composableBuilder(
      column: $table.resolutionSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnOrderings(column));
}

class $$PendingResolutionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingResolutionsTableTable> {
  $$PendingResolutionsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get noteTextSnippet => $composableBuilder(
      column: $table.noteTextSnippet, builder: (column) => column);

  GeneratedColumn<String> get candidatesJson => $composableBuilder(
      column: $table.candidatesJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get selectedContextId => $composableBuilder(
      column: $table.selectedContextId, builder: (column) => column);

  GeneratedColumn<String> get resolutionSource => $composableBuilder(
      column: $table.resolutionSource, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => column);
}

class $$PendingResolutionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PendingResolutionsTableTable,
    PendingResolutionsTableData,
    $$PendingResolutionsTableTableFilterComposer,
    $$PendingResolutionsTableTableOrderingComposer,
    $$PendingResolutionsTableTableAnnotationComposer,
    $$PendingResolutionsTableTableCreateCompanionBuilder,
    $$PendingResolutionsTableTableUpdateCompanionBuilder,
    (
      PendingResolutionsTableData,
      BaseReferences<_$AppDatabase, $PendingResolutionsTableTable,
          PendingResolutionsTableData>
    ),
    PendingResolutionsTableData,
    PrefetchHooks Function()> {
  $$PendingResolutionsTableTableTableManager(
      _$AppDatabase db, $PendingResolutionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingResolutionsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingResolutionsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingResolutionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> memoryId = const Value.absent(),
            Value<String> noteTextSnippet = const Value.absent(),
            Value<String> candidatesJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> selectedContextId = const Value.absent(),
            Value<String?> resolutionSource = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int?> resolvedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PendingResolutionsTableCompanion(
            id: id,
            memoryId: memoryId,
            noteTextSnippet: noteTextSnippet,
            candidatesJson: candidatesJson,
            status: status,
            selectedContextId: selectedContextId,
            resolutionSource: resolutionSource,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String memoryId,
            Value<String> noteTextSnippet = const Value.absent(),
            Value<String> candidatesJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> selectedContextId = const Value.absent(),
            Value<String?> resolutionSource = const Value.absent(),
            required int createdAt,
            Value<int?> resolvedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PendingResolutionsTableCompanion.insert(
            id: id,
            memoryId: memoryId,
            noteTextSnippet: noteTextSnippet,
            candidatesJson: candidatesJson,
            status: status,
            selectedContextId: selectedContextId,
            resolutionSource: resolutionSource,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendingResolutionsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $PendingResolutionsTableTable,
        PendingResolutionsTableData,
        $$PendingResolutionsTableTableFilterComposer,
        $$PendingResolutionsTableTableOrderingComposer,
        $$PendingResolutionsTableTableAnnotationComposer,
        $$PendingResolutionsTableTableCreateCompanionBuilder,
        $$PendingResolutionsTableTableUpdateCompanionBuilder,
        (
          PendingResolutionsTableData,
          BaseReferences<_$AppDatabase, $PendingResolutionsTableTable,
              PendingResolutionsTableData>
        ),
        PendingResolutionsTableData,
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
  $$ContextNodesTableTableTableManager get contextNodesTable =>
      $$ContextNodesTableTableTableManager(_db, _db.contextNodesTable);
  $$ContextEdgesTableTableTableManager get contextEdgesTable =>
      $$ContextEdgesTableTableTableManager(_db, _db.contextEdgesTable);
  $$MemoryContextsTableTableTableManager get memoryContextsTable =>
      $$MemoryContextsTableTableTableManager(_db, _db.memoryContextsTable);
  $$MemoryEvidenceTableTableTableManager get memoryEvidenceTable =>
      $$MemoryEvidenceTableTableTableManager(_db, _db.memoryEvidenceTable);
  $$PendingResolutionsTableTableTableManager get pendingResolutionsTable =>
      $$PendingResolutionsTableTableTableManager(
          _db, _db.pendingResolutionsTable);
}
