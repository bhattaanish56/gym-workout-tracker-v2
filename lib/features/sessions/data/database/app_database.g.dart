// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workoutDateMeta = const VerificationMeta(
    'workoutDate',
  );
  @override
  late final GeneratedColumn<String> workoutDate = GeneratedColumn<String>(
    'workout_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programIdMeta = const VerificationMeta(
    'programId',
  );
  @override
  late final GeneratedColumn<String> programId = GeneratedColumn<String>(
    'program_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _programDayIdMeta = const VerificationMeta(
    'programDayId',
  );
  @override
  late final GeneratedColumn<String> programDayId = GeneratedColumn<String>(
    'program_day_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _programSnapshotMeta = const VerificationMeta(
    'programSnapshot',
  );
  @override
  late final GeneratedColumn<String> programSnapshot = GeneratedColumn<String>(
    'program_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fulfilledScheduledDateMeta =
      const VerificationMeta('fulfilledScheduledDate');
  @override
  late final GeneratedColumn<String> fulfilledScheduledDate =
      GeneratedColumn<String>(
        'fulfilled_scheduled_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceType,
    startedAt,
    finishedAt,
    workoutDate,
    status,
    programId,
    programDayId,
    programSnapshot,
    fulfilledScheduledDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('workout_date')) {
      context.handle(
        _workoutDateMeta,
        workoutDate.isAcceptableOrUnknown(
          data['workout_date']!,
          _workoutDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('program_id')) {
      context.handle(
        _programIdMeta,
        programId.isAcceptableOrUnknown(data['program_id']!, _programIdMeta),
      );
    }
    if (data.containsKey('program_day_id')) {
      context.handle(
        _programDayIdMeta,
        programDayId.isAcceptableOrUnknown(
          data['program_day_id']!,
          _programDayIdMeta,
        ),
      );
    }
    if (data.containsKey('program_snapshot')) {
      context.handle(
        _programSnapshotMeta,
        programSnapshot.isAcceptableOrUnknown(
          data['program_snapshot']!,
          _programSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('fulfilled_scheduled_date')) {
      context.handle(
        _fulfilledScheduledDateMeta,
        fulfilledScheduledDate.isAcceptableOrUnknown(
          data['fulfilled_scheduled_date']!,
          _fulfilledScheduledDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      workoutDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      programId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_id'],
      ),
      programDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_day_id'],
      ),
      programSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_snapshot'],
      ),
      fulfilledScheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fulfilled_scheduled_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final String sourceType;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final String workoutDate;
  final String status;
  final String? programId;
  final String? programDayId;
  final String? programSnapshot;
  final String? fulfilledScheduledDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkoutSession({
    required this.id,
    required this.sourceType,
    required this.startedAt,
    this.finishedAt,
    required this.workoutDate,
    required this.status,
    this.programId,
    this.programDayId,
    this.programSnapshot,
    this.fulfilledScheduledDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_type'] = Variable<String>(sourceType);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['workout_date'] = Variable<String>(workoutDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || programId != null) {
      map['program_id'] = Variable<String>(programId);
    }
    if (!nullToAbsent || programDayId != null) {
      map['program_day_id'] = Variable<String>(programDayId);
    }
    if (!nullToAbsent || programSnapshot != null) {
      map['program_snapshot'] = Variable<String>(programSnapshot);
    }
    if (!nullToAbsent || fulfilledScheduledDate != null) {
      map['fulfilled_scheduled_date'] = Variable<String>(
        fulfilledScheduledDate,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      sourceType: Value(sourceType),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      workoutDate: Value(workoutDate),
      status: Value(status),
      programId: programId == null && nullToAbsent
          ? const Value.absent()
          : Value(programId),
      programDayId: programDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(programDayId),
      programSnapshot: programSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(programSnapshot),
      fulfilledScheduledDate: fulfilledScheduledDate == null && nullToAbsent
          ? const Value.absent()
          : Value(fulfilledScheduledDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<String>(json['id']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      workoutDate: serializer.fromJson<String>(json['workoutDate']),
      status: serializer.fromJson<String>(json['status']),
      programId: serializer.fromJson<String?>(json['programId']),
      programDayId: serializer.fromJson<String?>(json['programDayId']),
      programSnapshot: serializer.fromJson<String?>(json['programSnapshot']),
      fulfilledScheduledDate: serializer.fromJson<String?>(
        json['fulfilledScheduledDate'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceType': serializer.toJson<String>(sourceType),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'workoutDate': serializer.toJson<String>(workoutDate),
      'status': serializer.toJson<String>(status),
      'programId': serializer.toJson<String?>(programId),
      'programDayId': serializer.toJson<String?>(programDayId),
      'programSnapshot': serializer.toJson<String?>(programSnapshot),
      'fulfilledScheduledDate': serializer.toJson<String?>(
        fulfilledScheduledDate,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkoutSession copyWith({
    String? id,
    String? sourceType,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    String? workoutDate,
    String? status,
    Value<String?> programId = const Value.absent(),
    Value<String?> programDayId = const Value.absent(),
    Value<String?> programSnapshot = const Value.absent(),
    Value<String?> fulfilledScheduledDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkoutSession(
    id: id ?? this.id,
    sourceType: sourceType ?? this.sourceType,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    workoutDate: workoutDate ?? this.workoutDate,
    status: status ?? this.status,
    programId: programId.present ? programId.value : this.programId,
    programDayId: programDayId.present ? programDayId.value : this.programDayId,
    programSnapshot: programSnapshot.present
        ? programSnapshot.value
        : this.programSnapshot,
    fulfilledScheduledDate: fulfilledScheduledDate.present
        ? fulfilledScheduledDate.value
        : this.fulfilledScheduledDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      workoutDate: data.workoutDate.present
          ? data.workoutDate.value
          : this.workoutDate,
      status: data.status.present ? data.status.value : this.status,
      programId: data.programId.present ? data.programId.value : this.programId,
      programDayId: data.programDayId.present
          ? data.programDayId.value
          : this.programDayId,
      programSnapshot: data.programSnapshot.present
          ? data.programSnapshot.value
          : this.programSnapshot,
      fulfilledScheduledDate: data.fulfilledScheduledDate.present
          ? data.fulfilledScheduledDate.value
          : this.fulfilledScheduledDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('workoutDate: $workoutDate, ')
          ..write('status: $status, ')
          ..write('programId: $programId, ')
          ..write('programDayId: $programDayId, ')
          ..write('programSnapshot: $programSnapshot, ')
          ..write('fulfilledScheduledDate: $fulfilledScheduledDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceType,
    startedAt,
    finishedAt,
    workoutDate,
    status,
    programId,
    programDayId,
    programSnapshot,
    fulfilledScheduledDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.sourceType == this.sourceType &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.workoutDate == this.workoutDate &&
          other.status == this.status &&
          other.programId == this.programId &&
          other.programDayId == this.programDayId &&
          other.programSnapshot == this.programSnapshot &&
          other.fulfilledScheduledDate == this.fulfilledScheduledDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<String> sourceType;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<String> workoutDate;
  final Value<String> status;
  final Value<String?> programId;
  final Value<String?> programDayId;
  final Value<String?> programSnapshot;
  final Value<String?> fulfilledScheduledDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.workoutDate = const Value.absent(),
    this.status = const Value.absent(),
    this.programId = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.programSnapshot = const Value.absent(),
    this.fulfilledScheduledDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required String sourceType,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    required String workoutDate,
    required String status,
    this.programId = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.programSnapshot = const Value.absent(),
    this.fulfilledScheduledDate = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceType = Value(sourceType),
       startedAt = Value(startedAt),
       workoutDate = Value(workoutDate),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkoutSession> custom({
    Expression<String>? id,
    Expression<String>? sourceType,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<String>? workoutDate,
    Expression<String>? status,
    Expression<String>? programId,
    Expression<String>? programDayId,
    Expression<String>? programSnapshot,
    Expression<String>? fulfilledScheduledDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceType != null) 'source_type': sourceType,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (workoutDate != null) 'workout_date': workoutDate,
      if (status != null) 'status': status,
      if (programId != null) 'program_id': programId,
      if (programDayId != null) 'program_day_id': programDayId,
      if (programSnapshot != null) 'program_snapshot': programSnapshot,
      if (fulfilledScheduledDate != null)
        'fulfilled_scheduled_date': fulfilledScheduledDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceType,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<String>? workoutDate,
    Value<String>? status,
    Value<String?>? programId,
    Value<String?>? programDayId,
    Value<String?>? programSnapshot,
    Value<String?>? fulfilledScheduledDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      sourceType: sourceType ?? this.sourceType,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      workoutDate: workoutDate ?? this.workoutDate,
      status: status ?? this.status,
      programId: programId ?? this.programId,
      programDayId: programDayId ?? this.programDayId,
      programSnapshot: programSnapshot ?? this.programSnapshot,
      fulfilledScheduledDate:
          fulfilledScheduledDate ?? this.fulfilledScheduledDate,
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
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (workoutDate.present) {
      map['workout_date'] = Variable<String>(workoutDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (programId.present) {
      map['program_id'] = Variable<String>(programId.value);
    }
    if (programDayId.present) {
      map['program_day_id'] = Variable<String>(programDayId.value);
    }
    if (programSnapshot.present) {
      map['program_snapshot'] = Variable<String>(programSnapshot.value);
    }
    if (fulfilledScheduledDate.present) {
      map['fulfilled_scheduled_date'] = Variable<String>(
        fulfilledScheduledDate.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('workoutDate: $workoutDate, ')
          ..write('status: $status, ')
          ..write('programId: $programId, ')
          ..write('programDayId: $programDayId, ')
          ..write('programSnapshot: $programSnapshot, ')
          ..write('fulfilledScheduledDate: $fulfilledScheduledDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PerformedExercisesTable extends PerformedExercises
    with TableInfo<$PerformedExercisesTable, PerformedExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerformedExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snapshotJsonMeta = const VerificationMeta(
    'snapshotJson',
  );
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
    'snapshot_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    orderIndex,
    snapshotJson,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'performed_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerformedExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
        _snapshotJsonMeta,
        snapshotJson.isAcceptableOrUnknown(
          data['snapshot_json']!,
          _snapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotJsonMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerformedExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerformedExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      snapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_json'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PerformedExercisesTable createAlias(String alias) {
    return $PerformedExercisesTable(attachedDatabase, alias);
  }
}

class PerformedExercise extends DataClass
    implements Insertable<PerformedExercise> {
  final String id;
  final String sessionId;
  final int orderIndex;
  final String snapshotJson;
  final String? notes;
  const PerformedExercise({
    required this.id,
    required this.sessionId,
    required this.orderIndex,
    required this.snapshotJson,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['order_index'] = Variable<int>(orderIndex);
    map['snapshot_json'] = Variable<String>(snapshotJson);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PerformedExercisesCompanion toCompanion(bool nullToAbsent) {
    return PerformedExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      orderIndex: Value(orderIndex),
      snapshotJson: Value(snapshotJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PerformedExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerformedExercise(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      snapshotJson: serializer.fromJson<String>(json['snapshotJson']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'snapshotJson': serializer.toJson<String>(snapshotJson),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PerformedExercise copyWith({
    String? id,
    String? sessionId,
    int? orderIndex,
    String? snapshotJson,
    Value<String?> notes = const Value.absent(),
  }) => PerformedExercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    orderIndex: orderIndex ?? this.orderIndex,
    snapshotJson: snapshotJson ?? this.snapshotJson,
    notes: notes.present ? notes.value : this.notes,
  );
  PerformedExercise copyWithCompanion(PerformedExercisesCompanion data) {
    return PerformedExercise(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerformedExercise(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, orderIndex, snapshotJson, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerformedExercise &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.orderIndex == this.orderIndex &&
          other.snapshotJson == this.snapshotJson &&
          other.notes == this.notes);
}

class PerformedExercisesCompanion extends UpdateCompanion<PerformedExercise> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<int> orderIndex;
  final Value<String> snapshotJson;
  final Value<String?> notes;
  final Value<int> rowid;
  const PerformedExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PerformedExercisesCompanion.insert({
    required String id,
    required String sessionId,
    required int orderIndex,
    required String snapshotJson,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       orderIndex = Value(orderIndex),
       snapshotJson = Value(snapshotJson);
  static Insertable<PerformedExercise> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? orderIndex,
    Expression<String>? snapshotJson,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PerformedExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<int>? orderIndex,
    Value<String>? snapshotJson,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return PerformedExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      orderIndex: orderIndex ?? this.orderIndex,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerformedExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PerformedSetsTable extends PerformedSets
    with TableInfo<$PerformedSetsTable, PerformedSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerformedSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _performedExerciseIdMeta =
      const VerificationMeta('performedExerciseId');
  @override
  late final GeneratedColumn<String> performedExerciseId =
      GeneratedColumn<String>(
        'performed_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES performed_exercises (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loadGramsMeta = const VerificationMeta(
    'loadGrams',
  );
  @override
  late final GeneratedColumn<int> loadGrams = GeneratedColumn<int>(
    'load_grams',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    performedExerciseId,
    orderIndex,
    setType,
    loadGrams,
    reps,
    completed,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'performed_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerformedSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('performed_exercise_id')) {
      context.handle(
        _performedExerciseIdMeta,
        performedExerciseId.isAcceptableOrUnknown(
          data['performed_exercise_id']!,
          _performedExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performedExerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_setTypeMeta);
    }
    if (data.containsKey('load_grams')) {
      context.handle(
        _loadGramsMeta,
        loadGrams.isAcceptableOrUnknown(data['load_grams']!, _loadGramsMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerformedSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerformedSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      performedExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}performed_exercise_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
      loadGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}load_grams'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PerformedSetsTable createAlias(String alias) {
    return $PerformedSetsTable(attachedDatabase, alias);
  }
}

class PerformedSet extends DataClass implements Insertable<PerformedSet> {
  final String id;
  final String performedExerciseId;
  final int orderIndex;
  final String setType;
  final int? loadGrams;
  final int? reps;
  final bool completed;
  final String? notes;
  const PerformedSet({
    required this.id,
    required this.performedExerciseId,
    required this.orderIndex,
    required this.setType,
    this.loadGrams,
    this.reps,
    required this.completed,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['performed_exercise_id'] = Variable<String>(performedExerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    map['set_type'] = Variable<String>(setType);
    if (!nullToAbsent || loadGrams != null) {
      map['load_grams'] = Variable<int>(loadGrams);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PerformedSetsCompanion toCompanion(bool nullToAbsent) {
    return PerformedSetsCompanion(
      id: Value(id),
      performedExerciseId: Value(performedExerciseId),
      orderIndex: Value(orderIndex),
      setType: Value(setType),
      loadGrams: loadGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(loadGrams),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      completed: Value(completed),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PerformedSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerformedSet(
      id: serializer.fromJson<String>(json['id']),
      performedExerciseId: serializer.fromJson<String>(
        json['performedExerciseId'],
      ),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      setType: serializer.fromJson<String>(json['setType']),
      loadGrams: serializer.fromJson<int?>(json['loadGrams']),
      reps: serializer.fromJson<int?>(json['reps']),
      completed: serializer.fromJson<bool>(json['completed']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'performedExerciseId': serializer.toJson<String>(performedExerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'setType': serializer.toJson<String>(setType),
      'loadGrams': serializer.toJson<int?>(loadGrams),
      'reps': serializer.toJson<int?>(reps),
      'completed': serializer.toJson<bool>(completed),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PerformedSet copyWith({
    String? id,
    String? performedExerciseId,
    int? orderIndex,
    String? setType,
    Value<int?> loadGrams = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    bool? completed,
    Value<String?> notes = const Value.absent(),
  }) => PerformedSet(
    id: id ?? this.id,
    performedExerciseId: performedExerciseId ?? this.performedExerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
    setType: setType ?? this.setType,
    loadGrams: loadGrams.present ? loadGrams.value : this.loadGrams,
    reps: reps.present ? reps.value : this.reps,
    completed: completed ?? this.completed,
    notes: notes.present ? notes.value : this.notes,
  );
  PerformedSet copyWithCompanion(PerformedSetsCompanion data) {
    return PerformedSet(
      id: data.id.present ? data.id.value : this.id,
      performedExerciseId: data.performedExerciseId.present
          ? data.performedExerciseId.value
          : this.performedExerciseId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      setType: data.setType.present ? data.setType.value : this.setType,
      loadGrams: data.loadGrams.present ? data.loadGrams.value : this.loadGrams,
      reps: data.reps.present ? data.reps.value : this.reps,
      completed: data.completed.present ? data.completed.value : this.completed,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerformedSet(')
          ..write('id: $id, ')
          ..write('performedExerciseId: $performedExerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('setType: $setType, ')
          ..write('loadGrams: $loadGrams, ')
          ..write('reps: $reps, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    performedExerciseId,
    orderIndex,
    setType,
    loadGrams,
    reps,
    completed,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerformedSet &&
          other.id == this.id &&
          other.performedExerciseId == this.performedExerciseId &&
          other.orderIndex == this.orderIndex &&
          other.setType == this.setType &&
          other.loadGrams == this.loadGrams &&
          other.reps == this.reps &&
          other.completed == this.completed &&
          other.notes == this.notes);
}

class PerformedSetsCompanion extends UpdateCompanion<PerformedSet> {
  final Value<String> id;
  final Value<String> performedExerciseId;
  final Value<int> orderIndex;
  final Value<String> setType;
  final Value<int?> loadGrams;
  final Value<int?> reps;
  final Value<bool> completed;
  final Value<String?> notes;
  final Value<int> rowid;
  const PerformedSetsCompanion({
    this.id = const Value.absent(),
    this.performedExerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.setType = const Value.absent(),
    this.loadGrams = const Value.absent(),
    this.reps = const Value.absent(),
    this.completed = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PerformedSetsCompanion.insert({
    required String id,
    required String performedExerciseId,
    required int orderIndex,
    required String setType,
    this.loadGrams = const Value.absent(),
    this.reps = const Value.absent(),
    required bool completed,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       performedExerciseId = Value(performedExerciseId),
       orderIndex = Value(orderIndex),
       setType = Value(setType),
       completed = Value(completed);
  static Insertable<PerformedSet> custom({
    Expression<String>? id,
    Expression<String>? performedExerciseId,
    Expression<int>? orderIndex,
    Expression<String>? setType,
    Expression<int>? loadGrams,
    Expression<int>? reps,
    Expression<bool>? completed,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (performedExerciseId != null)
        'performed_exercise_id': performedExerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (setType != null) 'set_type': setType,
      if (loadGrams != null) 'load_grams': loadGrams,
      if (reps != null) 'reps': reps,
      if (completed != null) 'completed': completed,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PerformedSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? performedExerciseId,
    Value<int>? orderIndex,
    Value<String>? setType,
    Value<int?>? loadGrams,
    Value<int?>? reps,
    Value<bool>? completed,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return PerformedSetsCompanion(
      id: id ?? this.id,
      performedExerciseId: performedExerciseId ?? this.performedExerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      setType: setType ?? this.setType,
      loadGrams: loadGrams ?? this.loadGrams,
      reps: reps ?? this.reps,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (performedExerciseId.present) {
      map['performed_exercise_id'] = Variable<String>(
        performedExerciseId.value,
      );
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    if (loadGrams.present) {
      map['load_grams'] = Variable<int>(loadGrams.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerformedSetsCompanion(')
          ..write('id: $id, ')
          ..write('performedExerciseId: $performedExerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('setType: $setType, ')
          ..write('loadGrams: $loadGrams, ')
          ..write('reps: $reps, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomExercisesTable extends CustomExercises
    with TableInfo<$CustomExercisesTable, CustomExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryMuscleMeta = const VerificationMeta(
    'primaryMuscle',
  );
  @override
  late final GeneratedColumn<String> primaryMuscle = GeneratedColumn<String>(
    'primary_muscle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    equipment,
    primaryMuscle,
    instructions,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('primary_muscle')) {
      context.handle(
        _primaryMuscleMeta,
        primaryMuscle.isAcceptableOrUnknown(
          data['primary_muscle']!,
          _primaryMuscleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryMuscleMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      primaryMuscle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_muscle'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomExercisesTable createAlias(String alias) {
    return $CustomExercisesTable(attachedDatabase, alias);
  }
}

class CustomExercise extends DataClass implements Insertable<CustomExercise> {
  final String id;
  final String name;
  final String equipment;
  final String primaryMuscle;
  final String? instructions;
  final DateTime createdAt;
  const CustomExercise({
    required this.id,
    required this.name,
    required this.equipment,
    required this.primaryMuscle,
    this.instructions,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['equipment'] = Variable<String>(equipment);
    map['primary_muscle'] = Variable<String>(primaryMuscle);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomExercisesCompanion toCompanion(bool nullToAbsent) {
    return CustomExercisesCompanion(
      id: Value(id),
      name: Value(name),
      equipment: Value(equipment),
      primaryMuscle: Value(primaryMuscle),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      createdAt: Value(createdAt),
    );
  }

  factory CustomExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomExercise(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      equipment: serializer.fromJson<String>(json['equipment']),
      primaryMuscle: serializer.fromJson<String>(json['primaryMuscle']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'equipment': serializer.toJson<String>(equipment),
      'primaryMuscle': serializer.toJson<String>(primaryMuscle),
      'instructions': serializer.toJson<String?>(instructions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomExercise copyWith({
    String? id,
    String? name,
    String? equipment,
    String? primaryMuscle,
    Value<String?> instructions = const Value.absent(),
    DateTime? createdAt,
  }) => CustomExercise(
    id: id ?? this.id,
    name: name ?? this.name,
    equipment: equipment ?? this.equipment,
    primaryMuscle: primaryMuscle ?? this.primaryMuscle,
    instructions: instructions.present ? instructions.value : this.instructions,
    createdAt: createdAt ?? this.createdAt,
  );
  CustomExercise copyWithCompanion(CustomExercisesCompanion data) {
    return CustomExercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      primaryMuscle: data.primaryMuscle.present
          ? data.primaryMuscle.value
          : this.primaryMuscle,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomExercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('equipment: $equipment, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('instructions: $instructions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, equipment, primaryMuscle, instructions, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomExercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.equipment == this.equipment &&
          other.primaryMuscle == this.primaryMuscle &&
          other.instructions == this.instructions &&
          other.createdAt == this.createdAt);
}

class CustomExercisesCompanion extends UpdateCompanion<CustomExercise> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> equipment;
  final Value<String> primaryMuscle;
  final Value<String?> instructions;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.equipment = const Value.absent(),
    this.primaryMuscle = const Value.absent(),
    this.instructions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomExercisesCompanion.insert({
    required String id,
    required String name,
    required String equipment,
    required String primaryMuscle,
    this.instructions = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       equipment = Value(equipment),
       primaryMuscle = Value(primaryMuscle),
       createdAt = Value(createdAt);
  static Insertable<CustomExercise> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? equipment,
    Expression<String>? primaryMuscle,
    Expression<String>? instructions,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (equipment != null) 'equipment': equipment,
      if (primaryMuscle != null) 'primary_muscle': primaryMuscle,
      if (instructions != null) 'instructions': instructions,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? equipment,
    Value<String>? primaryMuscle,
    Value<String?>? instructions,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CustomExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      equipment: equipment ?? this.equipment,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      instructions: instructions ?? this.instructions,
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
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (primaryMuscle.present) {
      map['primary_muscle'] = Variable<String>(primaryMuscle.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('equipment: $equipment, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('instructions: $instructions, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramsTable extends Programs with TableInfo<$ProgramsTable, Program> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleModeMeta = const VerificationMeta(
    'scheduleMode',
  );
  @override
  late final GeneratedColumn<String> scheduleMode = GeneratedColumn<String>(
    'schedule_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    scheduleMode,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'programs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Program> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('schedule_mode')) {
      context.handle(
        _scheduleModeMeta,
        scheduleMode.isAcceptableOrUnknown(
          data['schedule_mode']!,
          _scheduleModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduleModeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Program map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Program(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      scheduleMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_mode'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProgramsTable createAlias(String alias) {
    return $ProgramsTable(attachedDatabase, alias);
  }
}

class Program extends DataClass implements Insertable<Program> {
  final String id;
  final String name;
  final String? description;
  final String scheduleMode;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Program({
    required this.id,
    required this.name,
    this.description,
    required this.scheduleMode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['schedule_mode'] = Variable<String>(scheduleMode);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProgramsCompanion toCompanion(bool nullToAbsent) {
    return ProgramsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      scheduleMode: Value(scheduleMode),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Program.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Program(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      scheduleMode: serializer.fromJson<String>(json['scheduleMode']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'scheduleMode': serializer.toJson<String>(scheduleMode),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Program copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? scheduleMode,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Program(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    scheduleMode: scheduleMode ?? this.scheduleMode,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Program copyWithCompanion(ProgramsCompanion data) {
    return Program(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      scheduleMode: data.scheduleMode.present
          ? data.scheduleMode.value
          : this.scheduleMode,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Program(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    scheduleMode,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Program &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.scheduleMode == this.scheduleMode &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProgramsCompanion extends UpdateCompanion<Program> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> scheduleMode;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProgramsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.scheduleMode = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String scheduleMode,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       scheduleMode = Value(scheduleMode),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Program> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? scheduleMode,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (scheduleMode != null) 'schedule_mode': scheduleMode,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? scheduleMode,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProgramsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      status: status ?? this.status,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (scheduleMode.present) {
      map['schedule_mode'] = Variable<String>(scheduleMode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramDaysTable extends ProgramDays
    with TableInfo<$ProgramDaysTable, ProgramDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programIdMeta = const VerificationMeta(
    'programId',
  );
  @override
  late final GeneratedColumn<String> programId = GeneratedColumn<String>(
    'program_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES programs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDescriptionMeta = const VerificationMeta(
    'targetDescription',
  );
  @override
  late final GeneratedColumn<String> targetDescription =
      GeneratedColumn<String>(
        'target_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    programId,
    orderIndex,
    name,
    targetDescription,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgramDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_id')) {
      context.handle(
        _programIdMeta,
        programId.isAcceptableOrUnknown(data['program_id']!, _programIdMeta),
      );
    } else if (isInserting) {
      context.missing(_programIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_description')) {
      context.handle(
        _targetDescriptionMeta,
        targetDescription.isAcceptableOrUnknown(
          data['target_description']!,
          _targetDescriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      programId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_description'],
      ),
    );
  }

  @override
  $ProgramDaysTable createAlias(String alias) {
    return $ProgramDaysTable(attachedDatabase, alias);
  }
}

class ProgramDay extends DataClass implements Insertable<ProgramDay> {
  final String id;
  final String programId;
  final int orderIndex;
  final String name;
  final String? targetDescription;
  const ProgramDay({
    required this.id,
    required this.programId,
    required this.orderIndex,
    required this.name,
    this.targetDescription,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_id'] = Variable<String>(programId);
    map['order_index'] = Variable<int>(orderIndex);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || targetDescription != null) {
      map['target_description'] = Variable<String>(targetDescription);
    }
    return map;
  }

  ProgramDaysCompanion toCompanion(bool nullToAbsent) {
    return ProgramDaysCompanion(
      id: Value(id),
      programId: Value(programId),
      orderIndex: Value(orderIndex),
      name: Value(name),
      targetDescription: targetDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDescription),
    );
  }

  factory ProgramDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramDay(
      id: serializer.fromJson<String>(json['id']),
      programId: serializer.fromJson<String>(json['programId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      name: serializer.fromJson<String>(json['name']),
      targetDescription: serializer.fromJson<String?>(
        json['targetDescription'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programId': serializer.toJson<String>(programId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'name': serializer.toJson<String>(name),
      'targetDescription': serializer.toJson<String?>(targetDescription),
    };
  }

  ProgramDay copyWith({
    String? id,
    String? programId,
    int? orderIndex,
    String? name,
    Value<String?> targetDescription = const Value.absent(),
  }) => ProgramDay(
    id: id ?? this.id,
    programId: programId ?? this.programId,
    orderIndex: orderIndex ?? this.orderIndex,
    name: name ?? this.name,
    targetDescription: targetDescription.present
        ? targetDescription.value
        : this.targetDescription,
  );
  ProgramDay copyWithCompanion(ProgramDaysCompanion data) {
    return ProgramDay(
      id: data.id.present ? data.id.value : this.id,
      programId: data.programId.present ? data.programId.value : this.programId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      name: data.name.present ? data.name.value : this.name,
      targetDescription: data.targetDescription.present
          ? data.targetDescription.value
          : this.targetDescription,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramDay(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('targetDescription: $targetDescription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, programId, orderIndex, name, targetDescription);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramDay &&
          other.id == this.id &&
          other.programId == this.programId &&
          other.orderIndex == this.orderIndex &&
          other.name == this.name &&
          other.targetDescription == this.targetDescription);
}

class ProgramDaysCompanion extends UpdateCompanion<ProgramDay> {
  final Value<String> id;
  final Value<String> programId;
  final Value<int> orderIndex;
  final Value<String> name;
  final Value<String?> targetDescription;
  final Value<int> rowid;
  const ProgramDaysCompanion({
    this.id = const Value.absent(),
    this.programId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.targetDescription = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramDaysCompanion.insert({
    required String id,
    required String programId,
    required int orderIndex,
    required String name,
    this.targetDescription = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       programId = Value(programId),
       orderIndex = Value(orderIndex),
       name = Value(name);
  static Insertable<ProgramDay> custom({
    Expression<String>? id,
    Expression<String>? programId,
    Expression<int>? orderIndex,
    Expression<String>? name,
    Expression<String>? targetDescription,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programId != null) 'program_id': programId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (name != null) 'name': name,
      if (targetDescription != null) 'target_description': targetDescription,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramDaysCompanion copyWith({
    Value<String>? id,
    Value<String>? programId,
    Value<int>? orderIndex,
    Value<String>? name,
    Value<String?>? targetDescription,
    Value<int>? rowid,
  }) {
    return ProgramDaysCompanion(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      orderIndex: orderIndex ?? this.orderIndex,
      name: name ?? this.name,
      targetDescription: targetDescription ?? this.targetDescription,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programId.present) {
      map['program_id'] = Variable<String>(programId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetDescription.present) {
      map['target_description'] = Variable<String>(targetDescription.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramDaysCompanion(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('targetDescription: $targetDescription, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlannedExercisesTable extends PlannedExercises
    with TableInfo<$PlannedExercisesTable, PlannedExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannedExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programDayIdMeta = const VerificationMeta(
    'programDayId',
  );
  @override
  late final GeneratedColumn<String> programDayId = GeneratedColumn<String>(
    'program_day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES program_days (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetRepsMinMeta = const VerificationMeta(
    'targetRepsMin',
  );
  @override
  late final GeneratedColumn<int> targetRepsMin = GeneratedColumn<int>(
    'target_reps_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetRepsMaxMeta = const VerificationMeta(
    'targetRepsMax',
  );
  @override
  late final GeneratedColumn<int> targetRepsMax = GeneratedColumn<int>(
    'target_reps_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetLoadGramsMeta = const VerificationMeta(
    'targetLoadGrams',
  );
  @override
  late final GeneratedColumn<int> targetLoadGrams = GeneratedColumn<int>(
    'target_load_grams',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    programDayId,
    exerciseId,
    orderIndex,
    targetSets,
    targetRepsMin,
    targetRepsMax,
    targetLoadGrams,
    restSeconds,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannedExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_day_id')) {
      context.handle(
        _programDayIdMeta,
        programDayId.isAcceptableOrUnknown(
          data['program_day_id']!,
          _programDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_programDayIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    }
    if (data.containsKey('target_reps_min')) {
      context.handle(
        _targetRepsMinMeta,
        targetRepsMin.isAcceptableOrUnknown(
          data['target_reps_min']!,
          _targetRepsMinMeta,
        ),
      );
    }
    if (data.containsKey('target_reps_max')) {
      context.handle(
        _targetRepsMaxMeta,
        targetRepsMax.isAcceptableOrUnknown(
          data['target_reps_max']!,
          _targetRepsMaxMeta,
        ),
      );
    }
    if (data.containsKey('target_load_grams')) {
      context.handle(
        _targetLoadGramsMeta,
        targetLoadGrams.isAcceptableOrUnknown(
          data['target_load_grams']!,
          _targetLoadGramsMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      programDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_day_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      ),
      targetRepsMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps_min'],
      ),
      targetRepsMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps_max'],
      ),
      targetLoadGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_load_grams'],
      ),
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PlannedExercisesTable createAlias(String alias) {
    return $PlannedExercisesTable(attachedDatabase, alias);
  }
}

class PlannedExercise extends DataClass implements Insertable<PlannedExercise> {
  final String id;
  final String programDayId;
  final String exerciseId;
  final int orderIndex;
  final int? targetSets;
  final int? targetRepsMin;
  final int? targetRepsMax;
  final int? targetLoadGrams;
  final int? restSeconds;
  final String? notes;
  const PlannedExercise({
    required this.id,
    required this.programDayId,
    required this.exerciseId,
    required this.orderIndex,
    this.targetSets,
    this.targetRepsMin,
    this.targetRepsMax,
    this.targetLoadGrams,
    this.restSeconds,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_day_id'] = Variable<String>(programDayId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || targetSets != null) {
      map['target_sets'] = Variable<int>(targetSets);
    }
    if (!nullToAbsent || targetRepsMin != null) {
      map['target_reps_min'] = Variable<int>(targetRepsMin);
    }
    if (!nullToAbsent || targetRepsMax != null) {
      map['target_reps_max'] = Variable<int>(targetRepsMax);
    }
    if (!nullToAbsent || targetLoadGrams != null) {
      map['target_load_grams'] = Variable<int>(targetLoadGrams);
    }
    if (!nullToAbsent || restSeconds != null) {
      map['rest_seconds'] = Variable<int>(restSeconds);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PlannedExercisesCompanion toCompanion(bool nullToAbsent) {
    return PlannedExercisesCompanion(
      id: Value(id),
      programDayId: Value(programDayId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
      targetSets: targetSets == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSets),
      targetRepsMin: targetRepsMin == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRepsMin),
      targetRepsMax: targetRepsMax == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRepsMax),
      targetLoadGrams: targetLoadGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(targetLoadGrams),
      restSeconds: restSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restSeconds),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PlannedExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedExercise(
      id: serializer.fromJson<String>(json['id']),
      programDayId: serializer.fromJson<String>(json['programDayId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      targetSets: serializer.fromJson<int?>(json['targetSets']),
      targetRepsMin: serializer.fromJson<int?>(json['targetRepsMin']),
      targetRepsMax: serializer.fromJson<int?>(json['targetRepsMax']),
      targetLoadGrams: serializer.fromJson<int?>(json['targetLoadGrams']),
      restSeconds: serializer.fromJson<int?>(json['restSeconds']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programDayId': serializer.toJson<String>(programDayId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'targetSets': serializer.toJson<int?>(targetSets),
      'targetRepsMin': serializer.toJson<int?>(targetRepsMin),
      'targetRepsMax': serializer.toJson<int?>(targetRepsMax),
      'targetLoadGrams': serializer.toJson<int?>(targetLoadGrams),
      'restSeconds': serializer.toJson<int?>(restSeconds),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PlannedExercise copyWith({
    String? id,
    String? programDayId,
    String? exerciseId,
    int? orderIndex,
    Value<int?> targetSets = const Value.absent(),
    Value<int?> targetRepsMin = const Value.absent(),
    Value<int?> targetRepsMax = const Value.absent(),
    Value<int?> targetLoadGrams = const Value.absent(),
    Value<int?> restSeconds = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => PlannedExercise(
    id: id ?? this.id,
    programDayId: programDayId ?? this.programDayId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
    targetSets: targetSets.present ? targetSets.value : this.targetSets,
    targetRepsMin: targetRepsMin.present
        ? targetRepsMin.value
        : this.targetRepsMin,
    targetRepsMax: targetRepsMax.present
        ? targetRepsMax.value
        : this.targetRepsMax,
    targetLoadGrams: targetLoadGrams.present
        ? targetLoadGrams.value
        : this.targetLoadGrams,
    restSeconds: restSeconds.present ? restSeconds.value : this.restSeconds,
    notes: notes.present ? notes.value : this.notes,
  );
  PlannedExercise copyWithCompanion(PlannedExercisesCompanion data) {
    return PlannedExercise(
      id: data.id.present ? data.id.value : this.id,
      programDayId: data.programDayId.present
          ? data.programDayId.value
          : this.programDayId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      targetRepsMin: data.targetRepsMin.present
          ? data.targetRepsMin.value
          : this.targetRepsMin,
      targetRepsMax: data.targetRepsMax.present
          ? data.targetRepsMax.value
          : this.targetRepsMax,
      targetLoadGrams: data.targetLoadGrams.present
          ? data.targetLoadGrams.value
          : this.targetLoadGrams,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedExercise(')
          ..write('id: $id, ')
          ..write('programDayId: $programDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetRepsMin: $targetRepsMin, ')
          ..write('targetRepsMax: $targetRepsMax, ')
          ..write('targetLoadGrams: $targetLoadGrams, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    programDayId,
    exerciseId,
    orderIndex,
    targetSets,
    targetRepsMin,
    targetRepsMax,
    targetLoadGrams,
    restSeconds,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedExercise &&
          other.id == this.id &&
          other.programDayId == this.programDayId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex &&
          other.targetSets == this.targetSets &&
          other.targetRepsMin == this.targetRepsMin &&
          other.targetRepsMax == this.targetRepsMax &&
          other.targetLoadGrams == this.targetLoadGrams &&
          other.restSeconds == this.restSeconds &&
          other.notes == this.notes);
}

class PlannedExercisesCompanion extends UpdateCompanion<PlannedExercise> {
  final Value<String> id;
  final Value<String> programDayId;
  final Value<String> exerciseId;
  final Value<int> orderIndex;
  final Value<int?> targetSets;
  final Value<int?> targetRepsMin;
  final Value<int?> targetRepsMax;
  final Value<int?> targetLoadGrams;
  final Value<int?> restSeconds;
  final Value<String?> notes;
  final Value<int> rowid;
  const PlannedExercisesCompanion({
    this.id = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetRepsMin = const Value.absent(),
    this.targetRepsMax = const Value.absent(),
    this.targetLoadGrams = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlannedExercisesCompanion.insert({
    required String id,
    required String programDayId,
    required String exerciseId,
    required int orderIndex,
    this.targetSets = const Value.absent(),
    this.targetRepsMin = const Value.absent(),
    this.targetRepsMax = const Value.absent(),
    this.targetLoadGrams = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       programDayId = Value(programDayId),
       exerciseId = Value(exerciseId),
       orderIndex = Value(orderIndex);
  static Insertable<PlannedExercise> custom({
    Expression<String>? id,
    Expression<String>? programDayId,
    Expression<String>? exerciseId,
    Expression<int>? orderIndex,
    Expression<int>? targetSets,
    Expression<int>? targetRepsMin,
    Expression<int>? targetRepsMax,
    Expression<int>? targetLoadGrams,
    Expression<int>? restSeconds,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programDayId != null) 'program_day_id': programDayId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (targetSets != null) 'target_sets': targetSets,
      if (targetRepsMin != null) 'target_reps_min': targetRepsMin,
      if (targetRepsMax != null) 'target_reps_max': targetRepsMax,
      if (targetLoadGrams != null) 'target_load_grams': targetLoadGrams,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlannedExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? programDayId,
    Value<String>? exerciseId,
    Value<int>? orderIndex,
    Value<int?>? targetSets,
    Value<int?>? targetRepsMin,
    Value<int?>? targetRepsMax,
    Value<int?>? targetLoadGrams,
    Value<int?>? restSeconds,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return PlannedExercisesCompanion(
      id: id ?? this.id,
      programDayId: programDayId ?? this.programDayId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      targetSets: targetSets ?? this.targetSets,
      targetRepsMin: targetRepsMin ?? this.targetRepsMin,
      targetRepsMax: targetRepsMax ?? this.targetRepsMax,
      targetLoadGrams: targetLoadGrams ?? this.targetLoadGrams,
      restSeconds: restSeconds ?? this.restSeconds,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programDayId.present) {
      map['program_day_id'] = Variable<String>(programDayId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (targetRepsMin.present) {
      map['target_reps_min'] = Variable<int>(targetRepsMin.value);
    }
    if (targetRepsMax.present) {
      map['target_reps_max'] = Variable<int>(targetRepsMax.value);
    }
    if (targetLoadGrams.present) {
      map['target_load_grams'] = Variable<int>(targetLoadGrams.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedExercisesCompanion(')
          ..write('id: $id, ')
          ..write('programDayId: $programDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetRepsMin: $targetRepsMin, ')
          ..write('targetRepsMax: $targetRepsMax, ')
          ..write('targetLoadGrams: $targetLoadGrams, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RotationStatesTable extends RotationStates
    with TableInfo<$RotationStatesTable, RotationState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RotationStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _programIdMeta = const VerificationMeta(
    'programId',
  );
  @override
  late final GeneratedColumn<String> programId = GeneratedColumn<String>(
    'program_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES programs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nextDayIndexMeta = const VerificationMeta(
    'nextDayIndex',
  );
  @override
  late final GeneratedColumn<int> nextDayIndex = GeneratedColumn<int>(
    'next_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastCompletionEventIdMeta =
      const VerificationMeta('lastCompletionEventId');
  @override
  late final GeneratedColumn<String> lastCompletionEventId =
      GeneratedColumn<String>(
        'last_completion_event_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    programId,
    nextDayIndex,
    lastCompletionEventId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rotation_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<RotationState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('program_id')) {
      context.handle(
        _programIdMeta,
        programId.isAcceptableOrUnknown(data['program_id']!, _programIdMeta),
      );
    } else if (isInserting) {
      context.missing(_programIdMeta);
    }
    if (data.containsKey('next_day_index')) {
      context.handle(
        _nextDayIndexMeta,
        nextDayIndex.isAcceptableOrUnknown(
          data['next_day_index']!,
          _nextDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDayIndexMeta);
    }
    if (data.containsKey('last_completion_event_id')) {
      context.handle(
        _lastCompletionEventIdMeta,
        lastCompletionEventId.isAcceptableOrUnknown(
          data['last_completion_event_id']!,
          _lastCompletionEventIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {programId};
  @override
  RotationState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RotationState(
      programId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_id'],
      )!,
      nextDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_day_index'],
      )!,
      lastCompletionEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_completion_event_id'],
      ),
    );
  }

  @override
  $RotationStatesTable createAlias(String alias) {
    return $RotationStatesTable(attachedDatabase, alias);
  }
}

class RotationState extends DataClass implements Insertable<RotationState> {
  final String programId;
  final int nextDayIndex;
  final String? lastCompletionEventId;
  const RotationState({
    required this.programId,
    required this.nextDayIndex,
    this.lastCompletionEventId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['program_id'] = Variable<String>(programId);
    map['next_day_index'] = Variable<int>(nextDayIndex);
    if (!nullToAbsent || lastCompletionEventId != null) {
      map['last_completion_event_id'] = Variable<String>(lastCompletionEventId);
    }
    return map;
  }

  RotationStatesCompanion toCompanion(bool nullToAbsent) {
    return RotationStatesCompanion(
      programId: Value(programId),
      nextDayIndex: Value(nextDayIndex),
      lastCompletionEventId: lastCompletionEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletionEventId),
    );
  }

  factory RotationState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RotationState(
      programId: serializer.fromJson<String>(json['programId']),
      nextDayIndex: serializer.fromJson<int>(json['nextDayIndex']),
      lastCompletionEventId: serializer.fromJson<String?>(
        json['lastCompletionEventId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'programId': serializer.toJson<String>(programId),
      'nextDayIndex': serializer.toJson<int>(nextDayIndex),
      'lastCompletionEventId': serializer.toJson<String?>(
        lastCompletionEventId,
      ),
    };
  }

  RotationState copyWith({
    String? programId,
    int? nextDayIndex,
    Value<String?> lastCompletionEventId = const Value.absent(),
  }) => RotationState(
    programId: programId ?? this.programId,
    nextDayIndex: nextDayIndex ?? this.nextDayIndex,
    lastCompletionEventId: lastCompletionEventId.present
        ? lastCompletionEventId.value
        : this.lastCompletionEventId,
  );
  RotationState copyWithCompanion(RotationStatesCompanion data) {
    return RotationState(
      programId: data.programId.present ? data.programId.value : this.programId,
      nextDayIndex: data.nextDayIndex.present
          ? data.nextDayIndex.value
          : this.nextDayIndex,
      lastCompletionEventId: data.lastCompletionEventId.present
          ? data.lastCompletionEventId.value
          : this.lastCompletionEventId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RotationState(')
          ..write('programId: $programId, ')
          ..write('nextDayIndex: $nextDayIndex, ')
          ..write('lastCompletionEventId: $lastCompletionEventId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(programId, nextDayIndex, lastCompletionEventId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RotationState &&
          other.programId == this.programId &&
          other.nextDayIndex == this.nextDayIndex &&
          other.lastCompletionEventId == this.lastCompletionEventId);
}

class RotationStatesCompanion extends UpdateCompanion<RotationState> {
  final Value<String> programId;
  final Value<int> nextDayIndex;
  final Value<String?> lastCompletionEventId;
  final Value<int> rowid;
  const RotationStatesCompanion({
    this.programId = const Value.absent(),
    this.nextDayIndex = const Value.absent(),
    this.lastCompletionEventId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RotationStatesCompanion.insert({
    required String programId,
    required int nextDayIndex,
    this.lastCompletionEventId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : programId = Value(programId),
       nextDayIndex = Value(nextDayIndex);
  static Insertable<RotationState> custom({
    Expression<String>? programId,
    Expression<int>? nextDayIndex,
    Expression<String>? lastCompletionEventId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (programId != null) 'program_id': programId,
      if (nextDayIndex != null) 'next_day_index': nextDayIndex,
      if (lastCompletionEventId != null)
        'last_completion_event_id': lastCompletionEventId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RotationStatesCompanion copyWith({
    Value<String>? programId,
    Value<int>? nextDayIndex,
    Value<String?>? lastCompletionEventId,
    Value<int>? rowid,
  }) {
    return RotationStatesCompanion(
      programId: programId ?? this.programId,
      nextDayIndex: nextDayIndex ?? this.nextDayIndex,
      lastCompletionEventId:
          lastCompletionEventId ?? this.lastCompletionEventId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (programId.present) {
      map['program_id'] = Variable<String>(programId.value);
    }
    if (nextDayIndex.present) {
      map['next_day_index'] = Variable<int>(nextDayIndex.value);
    }
    if (lastCompletionEventId.present) {
      map['last_completion_event_id'] = Variable<String>(
        lastCompletionEventId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RotationStatesCompanion(')
          ..write('programId: $programId, ')
          ..write('nextDayIndex: $nextDayIndex, ')
          ..write('lastCompletionEventId: $lastCompletionEventId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeekdayAssignmentsTable extends WeekdayAssignments
    with TableInfo<$WeekdayAssignmentsTable, WeekdayAssignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeekdayAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programIdMeta = const VerificationMeta(
    'programId',
  );
  @override
  late final GeneratedColumn<String> programId = GeneratedColumn<String>(
    'program_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES programs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignmentTypeMeta = const VerificationMeta(
    'assignmentType',
  );
  @override
  late final GeneratedColumn<String> assignmentType = GeneratedColumn<String>(
    'assignment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programDayIdMeta = const VerificationMeta(
    'programDayId',
  );
  @override
  late final GeneratedColumn<String> programDayId = GeneratedColumn<String>(
    'program_day_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES program_days (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    programId,
    weekday,
    assignmentType,
    programDayId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekday_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeekdayAssignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_id')) {
      context.handle(
        _programIdMeta,
        programId.isAcceptableOrUnknown(data['program_id']!, _programIdMeta),
      );
    } else if (isInserting) {
      context.missing(_programIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('assignment_type')) {
      context.handle(
        _assignmentTypeMeta,
        assignmentType.isAcceptableOrUnknown(
          data['assignment_type']!,
          _assignmentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignmentTypeMeta);
    }
    if (data.containsKey('program_day_id')) {
      context.handle(
        _programDayIdMeta,
        programDayId.isAcceptableOrUnknown(
          data['program_day_id']!,
          _programDayIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {programId, weekday},
  ];
  @override
  WeekdayAssignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeekdayAssignment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      programId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      assignmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assignment_type'],
      )!,
      programDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_day_id'],
      ),
    );
  }

  @override
  $WeekdayAssignmentsTable createAlias(String alias) {
    return $WeekdayAssignmentsTable(attachedDatabase, alias);
  }
}

class WeekdayAssignment extends DataClass
    implements Insertable<WeekdayAssignment> {
  final String id;
  final String programId;
  final int weekday;
  final String assignmentType;
  final String? programDayId;
  const WeekdayAssignment({
    required this.id,
    required this.programId,
    required this.weekday,
    required this.assignmentType,
    this.programDayId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_id'] = Variable<String>(programId);
    map['weekday'] = Variable<int>(weekday);
    map['assignment_type'] = Variable<String>(assignmentType);
    if (!nullToAbsent || programDayId != null) {
      map['program_day_id'] = Variable<String>(programDayId);
    }
    return map;
  }

  WeekdayAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return WeekdayAssignmentsCompanion(
      id: Value(id),
      programId: Value(programId),
      weekday: Value(weekday),
      assignmentType: Value(assignmentType),
      programDayId: programDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(programDayId),
    );
  }

  factory WeekdayAssignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeekdayAssignment(
      id: serializer.fromJson<String>(json['id']),
      programId: serializer.fromJson<String>(json['programId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      assignmentType: serializer.fromJson<String>(json['assignmentType']),
      programDayId: serializer.fromJson<String?>(json['programDayId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programId': serializer.toJson<String>(programId),
      'weekday': serializer.toJson<int>(weekday),
      'assignmentType': serializer.toJson<String>(assignmentType),
      'programDayId': serializer.toJson<String?>(programDayId),
    };
  }

  WeekdayAssignment copyWith({
    String? id,
    String? programId,
    int? weekday,
    String? assignmentType,
    Value<String?> programDayId = const Value.absent(),
  }) => WeekdayAssignment(
    id: id ?? this.id,
    programId: programId ?? this.programId,
    weekday: weekday ?? this.weekday,
    assignmentType: assignmentType ?? this.assignmentType,
    programDayId: programDayId.present ? programDayId.value : this.programDayId,
  );
  WeekdayAssignment copyWithCompanion(WeekdayAssignmentsCompanion data) {
    return WeekdayAssignment(
      id: data.id.present ? data.id.value : this.id,
      programId: data.programId.present ? data.programId.value : this.programId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      assignmentType: data.assignmentType.present
          ? data.assignmentType.value
          : this.assignmentType,
      programDayId: data.programDayId.present
          ? data.programDayId.value
          : this.programDayId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeekdayAssignment(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('weekday: $weekday, ')
          ..write('assignmentType: $assignmentType, ')
          ..write('programDayId: $programDayId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, programId, weekday, assignmentType, programDayId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeekdayAssignment &&
          other.id == this.id &&
          other.programId == this.programId &&
          other.weekday == this.weekday &&
          other.assignmentType == this.assignmentType &&
          other.programDayId == this.programDayId);
}

class WeekdayAssignmentsCompanion extends UpdateCompanion<WeekdayAssignment> {
  final Value<String> id;
  final Value<String> programId;
  final Value<int> weekday;
  final Value<String> assignmentType;
  final Value<String?> programDayId;
  final Value<int> rowid;
  const WeekdayAssignmentsCompanion({
    this.id = const Value.absent(),
    this.programId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.assignmentType = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeekdayAssignmentsCompanion.insert({
    required String id,
    required String programId,
    required int weekday,
    required String assignmentType,
    this.programDayId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       programId = Value(programId),
       weekday = Value(weekday),
       assignmentType = Value(assignmentType);
  static Insertable<WeekdayAssignment> custom({
    Expression<String>? id,
    Expression<String>? programId,
    Expression<int>? weekday,
    Expression<String>? assignmentType,
    Expression<String>? programDayId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programId != null) 'program_id': programId,
      if (weekday != null) 'weekday': weekday,
      if (assignmentType != null) 'assignment_type': assignmentType,
      if (programDayId != null) 'program_day_id': programDayId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeekdayAssignmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? programId,
    Value<int>? weekday,
    Value<String>? assignmentType,
    Value<String?>? programDayId,
    Value<int>? rowid,
  }) {
    return WeekdayAssignmentsCompanion(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      weekday: weekday ?? this.weekday,
      assignmentType: assignmentType ?? this.assignmentType,
      programDayId: programDayId ?? this.programDayId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programId.present) {
      map['program_id'] = Variable<String>(programId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (assignmentType.present) {
      map['assignment_type'] = Variable<String>(assignmentType.value);
    }
    if (programDayId.present) {
      map['program_day_id'] = Variable<String>(programDayId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeekdayAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('weekday: $weekday, ')
          ..write('assignmentType: $assignmentType, ')
          ..write('programDayId: $programDayId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyWeightEntriesTable extends BodyWeightEntries
    with TableInfo<$BodyWeightEntriesTable, BodyWeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyWeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightGramsMeta = const VerificationMeta(
    'weightGrams',
  );
  @override
  late final GeneratedColumn<int> weightGrams = GeneratedColumn<int>(
    'weight_grams',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredDateMeta = const VerificationMeta(
    'measuredDate',
  );
  @override
  late final GeneratedColumn<String> measuredDate = GeneratedColumn<String>(
    'measured_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weightGrams,
    measuredAt,
    measuredDate,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_weight_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyWeightEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
        _weightGramsMeta,
        weightGrams.isAcceptableOrUnknown(
          data['weight_grams']!,
          _weightGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weightGramsMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('measured_date')) {
      context.handle(
        _measuredDateMeta,
        measuredDate.isAcceptableOrUnknown(
          data['measured_date']!,
          _measuredDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measuredDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyWeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyWeightEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      weightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_grams'],
      )!,
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}measured_at'],
      )!,
      measuredDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measured_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BodyWeightEntriesTable createAlias(String alias) {
    return $BodyWeightEntriesTable(attachedDatabase, alias);
  }
}

class BodyWeightEntry extends DataClass implements Insertable<BodyWeightEntry> {
  final String id;
  final int weightGrams;
  final DateTime measuredAt;
  final String measuredDate;
  final String? notes;
  final DateTime createdAt;
  const BodyWeightEntry({
    required this.id,
    required this.weightGrams,
    required this.measuredAt,
    required this.measuredDate,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['weight_grams'] = Variable<int>(weightGrams);
    map['measured_at'] = Variable<DateTime>(measuredAt);
    map['measured_date'] = Variable<String>(measuredDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BodyWeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return BodyWeightEntriesCompanion(
      id: Value(id),
      weightGrams: Value(weightGrams),
      measuredAt: Value(measuredAt),
      measuredDate: Value(measuredDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory BodyWeightEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyWeightEntry(
      id: serializer.fromJson<String>(json['id']),
      weightGrams: serializer.fromJson<int>(json['weightGrams']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      measuredDate: serializer.fromJson<String>(json['measuredDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'weightGrams': serializer.toJson<int>(weightGrams),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'measuredDate': serializer.toJson<String>(measuredDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BodyWeightEntry copyWith({
    String? id,
    int? weightGrams,
    DateTime? measuredAt,
    String? measuredDate,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => BodyWeightEntry(
    id: id ?? this.id,
    weightGrams: weightGrams ?? this.weightGrams,
    measuredAt: measuredAt ?? this.measuredAt,
    measuredDate: measuredDate ?? this.measuredDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  BodyWeightEntry copyWithCompanion(BodyWeightEntriesCompanion data) {
    return BodyWeightEntry(
      id: data.id.present ? data.id.value : this.id,
      weightGrams: data.weightGrams.present
          ? data.weightGrams.value
          : this.weightGrams,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
      measuredDate: data.measuredDate.present
          ? data.measuredDate.value
          : this.measuredDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyWeightEntry(')
          ..write('id: $id, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('measuredDate: $measuredDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, weightGrams, measuredAt, measuredDate, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyWeightEntry &&
          other.id == this.id &&
          other.weightGrams == this.weightGrams &&
          other.measuredAt == this.measuredAt &&
          other.measuredDate == this.measuredDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class BodyWeightEntriesCompanion extends UpdateCompanion<BodyWeightEntry> {
  final Value<String> id;
  final Value<int> weightGrams;
  final Value<DateTime> measuredAt;
  final Value<String> measuredDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BodyWeightEntriesCompanion({
    this.id = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.measuredDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyWeightEntriesCompanion.insert({
    required String id,
    required int weightGrams,
    required DateTime measuredAt,
    required String measuredDate,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       weightGrams = Value(weightGrams),
       measuredAt = Value(measuredAt),
       measuredDate = Value(measuredDate),
       createdAt = Value(createdAt);
  static Insertable<BodyWeightEntry> custom({
    Expression<String>? id,
    Expression<int>? weightGrams,
    Expression<DateTime>? measuredAt,
    Expression<String>? measuredDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (measuredDate != null) 'measured_date': measuredDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyWeightEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? weightGrams,
    Value<DateTime>? measuredAt,
    Value<String>? measuredDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BodyWeightEntriesCompanion(
      id: id ?? this.id,
      weightGrams: weightGrams ?? this.weightGrams,
      measuredAt: measuredAt ?? this.measuredAt,
      measuredDate: measuredDate ?? this.measuredDate,
      notes: notes ?? this.notes,
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
    if (weightGrams.present) {
      map['weight_grams'] = Variable<int>(weightGrams.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (measuredDate.present) {
      map['measured_date'] = Variable<String>(measuredDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyWeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('measuredDate: $measuredDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<int> heightCm = GeneratedColumn<int>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [heightCm, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  UserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileData(
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_cm'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileData extends DataClass implements Insertable<UserProfileData> {
  final int? heightCm;
  final DateTime updatedAt;
  const UserProfileData({this.heightCm, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<int>(heightCm);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileData(
      heightCm: serializer.fromJson<int?>(json['heightCm']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'heightCm': serializer.toJson<int?>(heightCm),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfileData copyWith({
    Value<int?> heightCm = const Value.absent(),
    DateTime? updatedAt,
  }) => UserProfileData(
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfileData copyWithCompanion(UserProfileCompanion data) {
    return UserProfileData(
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileData(')
          ..write('heightCm: $heightCm, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(heightCm, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileData &&
          other.heightCm == this.heightCm &&
          other.updatedAt == this.updatedAt);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileData> {
  final Value<int?> heightCm;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserProfileCompanion({
    this.heightCm = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.heightCm = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : updatedAt = Value(updatedAt);
  static Insertable<UserProfileData> custom({
    Expression<int>? heightCm,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (heightCm != null) 'height_cm': heightCm,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfileCompanion copyWith({
    Value<int?>? heightCm,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProfileCompanion(
      heightCm: heightCm ?? this.heightCm,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (heightCm.present) {
      map['height_cm'] = Variable<int>(heightCm.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('heightCm: $heightCm, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $PerformedExercisesTable performedExercises =
      $PerformedExercisesTable(this);
  late final $PerformedSetsTable performedSets = $PerformedSetsTable(this);
  late final $CustomExercisesTable customExercises = $CustomExercisesTable(
    this,
  );
  late final $ProgramsTable programs = $ProgramsTable(this);
  late final $ProgramDaysTable programDays = $ProgramDaysTable(this);
  late final $PlannedExercisesTable plannedExercises = $PlannedExercisesTable(
    this,
  );
  late final $RotationStatesTable rotationStates = $RotationStatesTable(this);
  late final $WeekdayAssignmentsTable weekdayAssignments =
      $WeekdayAssignmentsTable(this);
  late final $BodyWeightEntriesTable bodyWeightEntries =
      $BodyWeightEntriesTable(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutSessions,
    performedExercises,
    performedSets,
    customExercises,
    programs,
    programDays,
    plannedExercises,
    rotationStates,
    weekdayAssignments,
    bodyWeightEntries,
    userProfile,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('performed_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'performed_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('performed_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'programs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('program_days', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'program_days',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('planned_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'programs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rotation_states', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'programs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('weekday_assignments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'program_days',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('weekday_assignments', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String id,
      required String sourceType,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      required String workoutDate,
      required String status,
      Value<String?> programId,
      Value<String?> programDayId,
      Value<String?> programSnapshot,
      Value<String?> fulfilledScheduledDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String> sourceType,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<String> workoutDate,
      Value<String> status,
      Value<String?> programId,
      Value<String?> programDayId,
      Value<String?> programSnapshot,
      Value<String?> fulfilledScheduledDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PerformedExercisesTable, List<PerformedExercise>>
  _performedExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.performedExercises,
        aliasName: 'workout_sessions__id__performed_exercises__session_id',
      );

  $$PerformedExercisesTableProcessedTableManager get performedExercisesRefs {
    final manager = $$PerformedExercisesTableTableManager(
      $_db,
      $_db.performedExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _performedExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutDate => $composableBuilder(
    column: $table.workoutDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programId => $composableBuilder(
    column: $table.programId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programDayId => $composableBuilder(
    column: $table.programDayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programSnapshot => $composableBuilder(
    column: $table.programSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fulfilledScheduledDate => $composableBuilder(
    column: $table.fulfilledScheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> performedExercisesRefs(
    Expression<bool> Function($$PerformedExercisesTableFilterComposer f) f,
  ) {
    final $$PerformedExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.performedExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformedExercisesTableFilterComposer(
            $db: $db,
            $table: $db.performedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutDate => $composableBuilder(
    column: $table.workoutDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programId => $composableBuilder(
    column: $table.programId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programDayId => $composableBuilder(
    column: $table.programDayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programSnapshot => $composableBuilder(
    column: $table.programSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fulfilledScheduledDate => $composableBuilder(
    column: $table.fulfilledScheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workoutDate => $composableBuilder(
    column: $table.workoutDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get programId =>
      $composableBuilder(column: $table.programId, builder: (column) => column);

  GeneratedColumn<String> get programDayId => $composableBuilder(
    column: $table.programDayId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get programSnapshot => $composableBuilder(
    column: $table.programSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fulfilledScheduledDate => $composableBuilder(
    column: $table.fulfilledScheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> performedExercisesRefs<T extends Object>(
    Expression<T> Function($$PerformedExercisesTableAnnotationComposer a) f,
  ) {
    final $$PerformedExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.performedExercises,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PerformedExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.performedExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({bool performedExercisesRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<String> workoutDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> programId = const Value.absent(),
                Value<String?> programDayId = const Value.absent(),
                Value<String?> programSnapshot = const Value.absent(),
                Value<String?> fulfilledScheduledDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                sourceType: sourceType,
                startedAt: startedAt,
                finishedAt: finishedAt,
                workoutDate: workoutDate,
                status: status,
                programId: programId,
                programDayId: programDayId,
                programSnapshot: programSnapshot,
                fulfilledScheduledDate: fulfilledScheduledDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceType,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                required String workoutDate,
                required String status,
                Value<String?> programId = const Value.absent(),
                Value<String?> programDayId = const Value.absent(),
                Value<String?> programSnapshot = const Value.absent(),
                Value<String?> fulfilledScheduledDate = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                sourceType: sourceType,
                startedAt: startedAt,
                finishedAt: finishedAt,
                workoutDate: workoutDate,
                status: status,
                programId: programId,
                programDayId: programDayId,
                programSnapshot: programSnapshot,
                fulfilledScheduledDate: fulfilledScheduledDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({performedExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (performedExercisesRefs) db.performedExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (performedExercisesRefs)
                    await $_getPrefetchedDataByColumns<
                      WorkoutSession,
                      $WorkoutSessionsTable,
                      PerformedExercise,
                      $PerformedExercisesTable
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences
                          ._performedExercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).performedExercisesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'session_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({bool performedExercisesRefs})
    >;
typedef $$PerformedExercisesTableCreateCompanionBuilder =
    PerformedExercisesCompanion Function({
      required String id,
      required String sessionId,
      required int orderIndex,
      required String snapshotJson,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$PerformedExercisesTableUpdateCompanionBuilder =
    PerformedExercisesCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<int> orderIndex,
      Value<String> snapshotJson,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$PerformedExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PerformedExercisesTable,
          PerformedExercise
        > {
  $$PerformedExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('performed_exercises__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PerformedSetsTable, List<PerformedSet>>
  _performedSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.performedSets,
    aliasName: 'performed_exercises__id__performed_sets__performed_exercise_id',
  );

  $$PerformedSetsTableProcessedTableManager get performedSetsRefs {
    final manager = $$PerformedSetsTableTableManager($_db, $_db.performedSets)
        .filter(
          (f) =>
              f.performedExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_performedSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PerformedExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $PerformedExercisesTable> {
  $$PerformedExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> performedSetsRefs(
    Expression<bool> Function($$PerformedSetsTableFilterComposer f) f,
  ) {
    final $$PerformedSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.performedSets,
      getReferencedColumn: (t) => t.performedExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformedSetsTableFilterComposer(
            $db: $db,
            $table: $db.performedSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PerformedExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $PerformedExercisesTable> {
  $$PerformedExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerformedExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerformedExercisesTable> {
  $$PerformedExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> performedSetsRefs<T extends Object>(
    Expression<T> Function($$PerformedSetsTableAnnotationComposer a) f,
  ) {
    final $$PerformedSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.performedSets,
      getReferencedColumn: (t) => t.performedExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformedSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.performedSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PerformedExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PerformedExercisesTable,
          PerformedExercise,
          $$PerformedExercisesTableFilterComposer,
          $$PerformedExercisesTableOrderingComposer,
          $$PerformedExercisesTableAnnotationComposer,
          $$PerformedExercisesTableCreateCompanionBuilder,
          $$PerformedExercisesTableUpdateCompanionBuilder,
          (PerformedExercise, $$PerformedExercisesTableReferences),
          PerformedExercise,
          PrefetchHooks Function({bool sessionId, bool performedSetsRefs})
        > {
  $$PerformedExercisesTableTableManager(
    _$AppDatabase db,
    $PerformedExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerformedExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerformedExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerformedExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> snapshotJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PerformedExercisesCompanion(
                id: id,
                sessionId: sessionId,
                orderIndex: orderIndex,
                snapshotJson: snapshotJson,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required int orderIndex,
                required String snapshotJson,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PerformedExercisesCompanion.insert(
                id: id,
                sessionId: sessionId,
                orderIndex: orderIndex,
                snapshotJson: snapshotJson,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PerformedExercisesTable, PerformedExercise>(
                    table,
                  ),
                  $$PerformedExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, performedSetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (performedSetsRefs) db.performedSets,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$PerformedExercisesTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$PerformedExercisesTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (performedSetsRefs)
                        await $_getPrefetchedDataByColumns<
                          PerformedExercise,
                          $PerformedExercisesTable,
                          PerformedSet,
                          $PerformedSetsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PerformedExercisesTableReferences
                              ._performedSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PerformedExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).performedSetsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'performed_exercise_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PerformedExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PerformedExercisesTable,
      PerformedExercise,
      $$PerformedExercisesTableFilterComposer,
      $$PerformedExercisesTableOrderingComposer,
      $$PerformedExercisesTableAnnotationComposer,
      $$PerformedExercisesTableCreateCompanionBuilder,
      $$PerformedExercisesTableUpdateCompanionBuilder,
      (PerformedExercise, $$PerformedExercisesTableReferences),
      PerformedExercise,
      PrefetchHooks Function({bool sessionId, bool performedSetsRefs})
    >;
typedef $$PerformedSetsTableCreateCompanionBuilder =
    PerformedSetsCompanion Function({
      required String id,
      required String performedExerciseId,
      required int orderIndex,
      required String setType,
      Value<int?> loadGrams,
      Value<int?> reps,
      required bool completed,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$PerformedSetsTableUpdateCompanionBuilder =
    PerformedSetsCompanion Function({
      Value<String> id,
      Value<String> performedExerciseId,
      Value<int> orderIndex,
      Value<String> setType,
      Value<int?> loadGrams,
      Value<int?> reps,
      Value<bool> completed,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$PerformedSetsTableReferences
    extends BaseReferences<_$AppDatabase, $PerformedSetsTable, PerformedSet> {
  $$PerformedSetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PerformedExercisesTable _performedExerciseIdTable(_$AppDatabase db) =>
      db.performedExercises.createAlias(
        'performed_sets__performed_exercise_id__performed_exercises__id',
      );

  $$PerformedExercisesTableProcessedTableManager get performedExerciseId {
    final $_column = $_itemColumn<String>('performed_exercise_id')!;

    final manager = $$PerformedExercisesTableTableManager(
      $_db,
      $_db.performedExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_performedExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PerformedSetsTableFilterComposer
    extends Composer<_$AppDatabase, $PerformedSetsTable> {
  $$PerformedSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loadGrams => $composableBuilder(
    column: $table.loadGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PerformedExercisesTableFilterComposer get performedExerciseId {
    final $$PerformedExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.performedExerciseId,
      referencedTable: $db.performedExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformedExercisesTableFilterComposer(
            $db: $db,
            $table: $db.performedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerformedSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $PerformedSetsTable> {
  $$PerformedSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loadGrams => $composableBuilder(
    column: $table.loadGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PerformedExercisesTableOrderingComposer get performedExerciseId {
    final $$PerformedExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.performedExerciseId,
      referencedTable: $db.performedExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformedExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.performedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerformedSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerformedSetsTable> {
  $$PerformedSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<int> get loadGrams =>
      $composableBuilder(column: $table.loadGrams, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PerformedExercisesTableAnnotationComposer get performedExerciseId {
    final $$PerformedExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.performedExerciseId,
          referencedTable: $db.performedExercises,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PerformedExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.performedExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PerformedSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PerformedSetsTable,
          PerformedSet,
          $$PerformedSetsTableFilterComposer,
          $$PerformedSetsTableOrderingComposer,
          $$PerformedSetsTableAnnotationComposer,
          $$PerformedSetsTableCreateCompanionBuilder,
          $$PerformedSetsTableUpdateCompanionBuilder,
          (PerformedSet, $$PerformedSetsTableReferences),
          PerformedSet,
          PrefetchHooks Function({bool performedExerciseId})
        > {
  $$PerformedSetsTableTableManager(_$AppDatabase db, $PerformedSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerformedSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerformedSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerformedSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> performedExerciseId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> setType = const Value.absent(),
                Value<int?> loadGrams = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PerformedSetsCompanion(
                id: id,
                performedExerciseId: performedExerciseId,
                orderIndex: orderIndex,
                setType: setType,
                loadGrams: loadGrams,
                reps: reps,
                completed: completed,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String performedExerciseId,
                required int orderIndex,
                required String setType,
                Value<int?> loadGrams = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                required bool completed,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PerformedSetsCompanion.insert(
                id: id,
                performedExerciseId: performedExerciseId,
                orderIndex: orderIndex,
                setType: setType,
                loadGrams: loadGrams,
                reps: reps,
                completed: completed,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PerformedSetsTable, PerformedSet>(table),
                  $$PerformedSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({performedExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (performedExerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.performedExerciseId,
                                referencedTable: $$PerformedSetsTableReferences
                                    ._performedExerciseIdTable(db),
                                referencedColumn: $$PerformedSetsTableReferences
                                    ._performedExerciseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PerformedSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PerformedSetsTable,
      PerformedSet,
      $$PerformedSetsTableFilterComposer,
      $$PerformedSetsTableOrderingComposer,
      $$PerformedSetsTableAnnotationComposer,
      $$PerformedSetsTableCreateCompanionBuilder,
      $$PerformedSetsTableUpdateCompanionBuilder,
      (PerformedSet, $$PerformedSetsTableReferences),
      PerformedSet,
      PrefetchHooks Function({bool performedExerciseId})
    >;
typedef $$CustomExercisesTableCreateCompanionBuilder =
    CustomExercisesCompanion Function({
      required String id,
      required String name,
      required String equipment,
      required String primaryMuscle,
      Value<String?> instructions,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CustomExercisesTableUpdateCompanionBuilder =
    CustomExercisesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> equipment,
      Value<String> primaryMuscle,
      Value<String?> instructions,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CustomExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryMuscle => $composableBuilder(
    column: $table.primaryMuscle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscle => $composableBuilder(
    column: $table.primaryMuscle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableAnnotationComposer({
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

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get primaryMuscle => $composableBuilder(
    column: $table.primaryMuscle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomExercisesTable,
          CustomExercise,
          $$CustomExercisesTableFilterComposer,
          $$CustomExercisesTableOrderingComposer,
          $$CustomExercisesTableAnnotationComposer,
          $$CustomExercisesTableCreateCompanionBuilder,
          $$CustomExercisesTableUpdateCompanionBuilder,
          (
            CustomExercise,
            BaseReferences<
              _$AppDatabase,
              $CustomExercisesTable,
              CustomExercise
            >,
          ),
          CustomExercise,
          PrefetchHooks Function()
        > {
  $$CustomExercisesTableTableManager(
    _$AppDatabase db,
    $CustomExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<String> primaryMuscle = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomExercisesCompanion(
                id: id,
                name: name,
                equipment: equipment,
                primaryMuscle: primaryMuscle,
                instructions: instructions,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String equipment,
                required String primaryMuscle,
                Value<String?> instructions = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CustomExercisesCompanion.insert(
                id: id,
                name: name,
                equipment: equipment,
                primaryMuscle: primaryMuscle,
                instructions: instructions,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomExercisesTable, CustomExercise>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CustomExercisesTable,
                    CustomExercise
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomExercisesTable,
      CustomExercise,
      $$CustomExercisesTableFilterComposer,
      $$CustomExercisesTableOrderingComposer,
      $$CustomExercisesTableAnnotationComposer,
      $$CustomExercisesTableCreateCompanionBuilder,
      $$CustomExercisesTableUpdateCompanionBuilder,
      (
        CustomExercise,
        BaseReferences<_$AppDatabase, $CustomExercisesTable, CustomExercise>,
      ),
      CustomExercise,
      PrefetchHooks Function()
    >;
typedef $$ProgramsTableCreateCompanionBuilder =
    ProgramsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required String scheduleMode,
      required String status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProgramsTableUpdateCompanionBuilder =
    ProgramsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> scheduleMode,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProgramsTableReferences
    extends BaseReferences<_$AppDatabase, $ProgramsTable, Program> {
  $$ProgramsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProgramDaysTable, List<ProgramDay>>
  _programDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.programDays,
    aliasName: 'programs__id__program_days__program_id',
  );

  $$ProgramDaysTableProcessedTableManager get programDaysRefs {
    final manager = $$ProgramDaysTableTableManager(
      $_db,
      $_db.programDays,
    ).filter((f) => f.programId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_programDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RotationStatesTable, List<RotationState>>
  _rotationStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rotationStates,
    aliasName: 'programs__id__rotation_states__program_id',
  );

  $$RotationStatesTableProcessedTableManager get rotationStatesRefs {
    final manager = $$RotationStatesTableTableManager(
      $_db,
      $_db.rotationStates,
    ).filter((f) => f.programId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rotationStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeekdayAssignmentsTable, List<WeekdayAssignment>>
  _weekdayAssignmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weekdayAssignments,
        aliasName: 'programs__id__weekday_assignments__program_id',
      );

  $$WeekdayAssignmentsTableProcessedTableManager get weekdayAssignmentsRefs {
    final manager = $$WeekdayAssignmentsTableTableManager(
      $_db,
      $_db.weekdayAssignments,
    ).filter((f) => f.programId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weekdayAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProgramsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleMode => $composableBuilder(
    column: $table.scheduleMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> programDaysRefs(
    Expression<bool> Function($$ProgramDaysTableFilterComposer f) f,
  ) {
    final $$ProgramDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.programId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableFilterComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rotationStatesRefs(
    Expression<bool> Function($$RotationStatesTableFilterComposer f) f,
  ) {
    final $$RotationStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rotationStates,
      getReferencedColumn: (t) => t.programId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RotationStatesTableFilterComposer(
            $db: $db,
            $table: $db.rotationStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weekdayAssignmentsRefs(
    Expression<bool> Function($$WeekdayAssignmentsTableFilterComposer f) f,
  ) {
    final $$WeekdayAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weekdayAssignments,
      getReferencedColumn: (t) => t.programId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekdayAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.weekdayAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgramsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleMode => $composableBuilder(
    column: $table.scheduleMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgramsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduleMode => $composableBuilder(
    column: $table.scheduleMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> programDaysRefs<T extends Object>(
    Expression<T> Function($$ProgramDaysTableAnnotationComposer a) f,
  ) {
    final $$ProgramDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.programId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rotationStatesRefs<T extends Object>(
    Expression<T> Function($$RotationStatesTableAnnotationComposer a) f,
  ) {
    final $$RotationStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rotationStates,
      getReferencedColumn: (t) => t.programId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RotationStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.rotationStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weekdayAssignmentsRefs<T extends Object>(
    Expression<T> Function($$WeekdayAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$WeekdayAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weekdayAssignments,
          getReferencedColumn: (t) => t.programId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeekdayAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.weekdayAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProgramsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramsTable,
          Program,
          $$ProgramsTableFilterComposer,
          $$ProgramsTableOrderingComposer,
          $$ProgramsTableAnnotationComposer,
          $$ProgramsTableCreateCompanionBuilder,
          $$ProgramsTableUpdateCompanionBuilder,
          (Program, $$ProgramsTableReferences),
          Program,
          PrefetchHooks Function({
            bool programDaysRefs,
            bool rotationStatesRefs,
            bool weekdayAssignmentsRefs,
          })
        > {
  $$ProgramsTableTableManager(_$AppDatabase db, $ProgramsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> scheduleMode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramsCompanion(
                id: id,
                name: name,
                description: description,
                scheduleMode: scheduleMode,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required String scheduleMode,
                required String status,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProgramsCompanion.insert(
                id: id,
                name: name,
                description: description,
                scheduleMode: scheduleMode,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgramsTable, Program>(table),
                  $$ProgramsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                programDaysRefs = false,
                rotationStatesRefs = false,
                weekdayAssignmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (programDaysRefs) db.programDays,
                    if (rotationStatesRefs) db.rotationStates,
                    if (weekdayAssignmentsRefs) db.weekdayAssignments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (programDaysRefs)
                        await $_getPrefetchedDataByColumns<
                          Program,
                          $ProgramsTable,
                          ProgramDay,
                          $ProgramDaysTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramsTableReferences
                              ._programDaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramsTableReferences(
                                db,
                                table,
                                p0,
                              ).programDaysRefs,
                          currentColumn: 'id',
                          referencedColumn: 'program_id',
                          typedResults: items,
                        ),
                      if (rotationStatesRefs)
                        await $_getPrefetchedDataByColumns<
                          Program,
                          $ProgramsTable,
                          RotationState,
                          $RotationStatesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramsTableReferences
                              ._rotationStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramsTableReferences(
                                db,
                                table,
                                p0,
                              ).rotationStatesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'program_id',
                          typedResults: items,
                        ),
                      if (weekdayAssignmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Program,
                          $ProgramsTable,
                          WeekdayAssignment,
                          $WeekdayAssignmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramsTableReferences
                              ._weekdayAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramsTableReferences(
                                db,
                                table,
                                p0,
                              ).weekdayAssignmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'program_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProgramsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramsTable,
      Program,
      $$ProgramsTableFilterComposer,
      $$ProgramsTableOrderingComposer,
      $$ProgramsTableAnnotationComposer,
      $$ProgramsTableCreateCompanionBuilder,
      $$ProgramsTableUpdateCompanionBuilder,
      (Program, $$ProgramsTableReferences),
      Program,
      PrefetchHooks Function({
        bool programDaysRefs,
        bool rotationStatesRefs,
        bool weekdayAssignmentsRefs,
      })
    >;
typedef $$ProgramDaysTableCreateCompanionBuilder =
    ProgramDaysCompanion Function({
      required String id,
      required String programId,
      required int orderIndex,
      required String name,
      Value<String?> targetDescription,
      Value<int> rowid,
    });
typedef $$ProgramDaysTableUpdateCompanionBuilder =
    ProgramDaysCompanion Function({
      Value<String> id,
      Value<String> programId,
      Value<int> orderIndex,
      Value<String> name,
      Value<String?> targetDescription,
      Value<int> rowid,
    });

final class $$ProgramDaysTableReferences
    extends BaseReferences<_$AppDatabase, $ProgramDaysTable, ProgramDay> {
  $$ProgramDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProgramsTable _programIdTable(_$AppDatabase db) =>
      db.programs.createAlias('program_days__program_id__programs__id');

  $$ProgramsTableProcessedTableManager get programId {
    final $_column = $_itemColumn<String>('program_id')!;

    final manager = $$ProgramsTableTableManager(
      $_db,
      $_db.programs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlannedExercisesTable, List<PlannedExercise>>
  _plannedExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plannedExercises,
    aliasName: 'program_days__id__planned_exercises__program_day_id',
  );

  $$PlannedExercisesTableProcessedTableManager get plannedExercisesRefs {
    final manager = $$PlannedExercisesTableTableManager(
      $_db,
      $_db.plannedExercises,
    ).filter((f) => f.programDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _plannedExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeekdayAssignmentsTable, List<WeekdayAssignment>>
  _weekdayAssignmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weekdayAssignments,
        aliasName: 'program_days__id__weekday_assignments__program_day_id',
      );

  $$WeekdayAssignmentsTableProcessedTableManager get weekdayAssignmentsRefs {
    final manager = $$WeekdayAssignmentsTableTableManager(
      $_db,
      $_db.weekdayAssignments,
    ).filter((f) => f.programDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weekdayAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProgramDaysTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetDescription => $composableBuilder(
    column: $table.targetDescription,
    builder: (column) => ColumnFilters(column),
  );

  $$ProgramsTableFilterComposer get programId {
    final $$ProgramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableFilterComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> plannedExercisesRefs(
    Expression<bool> Function($$PlannedExercisesTableFilterComposer f) f,
  ) {
    final $$PlannedExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedExercises,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedExercisesTableFilterComposer(
            $db: $db,
            $table: $db.plannedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weekdayAssignmentsRefs(
    Expression<bool> Function($$WeekdayAssignmentsTableFilterComposer f) f,
  ) {
    final $$WeekdayAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weekdayAssignments,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekdayAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.weekdayAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgramDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetDescription => $composableBuilder(
    column: $table.targetDescription,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProgramsTableOrderingComposer get programId {
    final $$ProgramsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableOrderingComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgramDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get targetDescription => $composableBuilder(
    column: $table.targetDescription,
    builder: (column) => column,
  );

  $$ProgramsTableAnnotationComposer get programId {
    final $$ProgramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableAnnotationComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> plannedExercisesRefs<T extends Object>(
    Expression<T> Function($$PlannedExercisesTableAnnotationComposer a) f,
  ) {
    final $$PlannedExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedExercises,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.plannedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weekdayAssignmentsRefs<T extends Object>(
    Expression<T> Function($$WeekdayAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$WeekdayAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weekdayAssignments,
          getReferencedColumn: (t) => t.programDayId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeekdayAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.weekdayAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProgramDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramDaysTable,
          ProgramDay,
          $$ProgramDaysTableFilterComposer,
          $$ProgramDaysTableOrderingComposer,
          $$ProgramDaysTableAnnotationComposer,
          $$ProgramDaysTableCreateCompanionBuilder,
          $$ProgramDaysTableUpdateCompanionBuilder,
          (ProgramDay, $$ProgramDaysTableReferences),
          ProgramDay,
          PrefetchHooks Function({
            bool programId,
            bool plannedExercisesRefs,
            bool weekdayAssignmentsRefs,
          })
        > {
  $$ProgramDaysTableTableManager(_$AppDatabase db, $ProgramDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> programId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> targetDescription = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramDaysCompanion(
                id: id,
                programId: programId,
                orderIndex: orderIndex,
                name: name,
                targetDescription: targetDescription,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String programId,
                required int orderIndex,
                required String name,
                Value<String?> targetDescription = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramDaysCompanion.insert(
                id: id,
                programId: programId,
                orderIndex: orderIndex,
                name: name,
                targetDescription: targetDescription,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgramDaysTable, ProgramDay>(table),
                  $$ProgramDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                programId = false,
                plannedExercisesRefs = false,
                weekdayAssignmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (plannedExercisesRefs) db.plannedExercises,
                    if (weekdayAssignmentsRefs) db.weekdayAssignments,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (programId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.programId,
                                    referencedTable:
                                        $$ProgramDaysTableReferences
                                            ._programIdTable(db),
                                    referencedColumn:
                                        $$ProgramDaysTableReferences
                                            ._programIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (plannedExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          ProgramDay,
                          $ProgramDaysTable,
                          PlannedExercise,
                          $PlannedExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramDaysTableReferences
                              ._plannedExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).plannedExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'program_day_id',
                          typedResults: items,
                        ),
                      if (weekdayAssignmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProgramDay,
                          $ProgramDaysTable,
                          WeekdayAssignment,
                          $WeekdayAssignmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramDaysTableReferences
                              ._weekdayAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).weekdayAssignmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'program_day_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProgramDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramDaysTable,
      ProgramDay,
      $$ProgramDaysTableFilterComposer,
      $$ProgramDaysTableOrderingComposer,
      $$ProgramDaysTableAnnotationComposer,
      $$ProgramDaysTableCreateCompanionBuilder,
      $$ProgramDaysTableUpdateCompanionBuilder,
      (ProgramDay, $$ProgramDaysTableReferences),
      ProgramDay,
      PrefetchHooks Function({
        bool programId,
        bool plannedExercisesRefs,
        bool weekdayAssignmentsRefs,
      })
    >;
typedef $$PlannedExercisesTableCreateCompanionBuilder =
    PlannedExercisesCompanion Function({
      required String id,
      required String programDayId,
      required String exerciseId,
      required int orderIndex,
      Value<int?> targetSets,
      Value<int?> targetRepsMin,
      Value<int?> targetRepsMax,
      Value<int?> targetLoadGrams,
      Value<int?> restSeconds,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$PlannedExercisesTableUpdateCompanionBuilder =
    PlannedExercisesCompanion Function({
      Value<String> id,
      Value<String> programDayId,
      Value<String> exerciseId,
      Value<int> orderIndex,
      Value<int?> targetSets,
      Value<int?> targetRepsMin,
      Value<int?> targetRepsMax,
      Value<int?> targetLoadGrams,
      Value<int?> restSeconds,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$PlannedExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PlannedExercisesTable, PlannedExercise> {
  $$PlannedExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProgramDaysTable _programDayIdTable(_$AppDatabase db) => db
      .programDays
      .createAlias('planned_exercises__program_day_id__program_days__id');

  $$ProgramDaysTableProcessedTableManager get programDayId {
    final $_column = $_itemColumn<String>('program_day_id')!;

    final manager = $$ProgramDaysTableTableManager(
      $_db,
      $_db.programDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlannedExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $PlannedExercisesTable> {
  $$PlannedExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetRepsMin => $composableBuilder(
    column: $table.targetRepsMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetRepsMax => $composableBuilder(
    column: $table.targetRepsMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetLoadGrams => $composableBuilder(
    column: $table.targetLoadGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ProgramDaysTableFilterComposer get programDayId {
    final $$ProgramDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableFilterComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlannedExercisesTable> {
  $$PlannedExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetRepsMin => $composableBuilder(
    column: $table.targetRepsMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetRepsMax => $composableBuilder(
    column: $table.targetRepsMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetLoadGrams => $composableBuilder(
    column: $table.targetLoadGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProgramDaysTableOrderingComposer get programDayId {
    final $$ProgramDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableOrderingComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlannedExercisesTable> {
  $$PlannedExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetRepsMin => $composableBuilder(
    column: $table.targetRepsMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetRepsMax => $composableBuilder(
    column: $table.targetRepsMax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetLoadGrams => $composableBuilder(
    column: $table.targetLoadGrams,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ProgramDaysTableAnnotationComposer get programDayId {
    final $$ProgramDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlannedExercisesTable,
          PlannedExercise,
          $$PlannedExercisesTableFilterComposer,
          $$PlannedExercisesTableOrderingComposer,
          $$PlannedExercisesTableAnnotationComposer,
          $$PlannedExercisesTableCreateCompanionBuilder,
          $$PlannedExercisesTableUpdateCompanionBuilder,
          (PlannedExercise, $$PlannedExercisesTableReferences),
          PlannedExercise,
          PrefetchHooks Function({bool programDayId})
        > {
  $$PlannedExercisesTableTableManager(
    _$AppDatabase db,
    $PlannedExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannedExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannedExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannedExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> programDayId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int?> targetSets = const Value.absent(),
                Value<int?> targetRepsMin = const Value.absent(),
                Value<int?> targetRepsMax = const Value.absent(),
                Value<int?> targetLoadGrams = const Value.absent(),
                Value<int?> restSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlannedExercisesCompanion(
                id: id,
                programDayId: programDayId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                targetSets: targetSets,
                targetRepsMin: targetRepsMin,
                targetRepsMax: targetRepsMax,
                targetLoadGrams: targetLoadGrams,
                restSeconds: restSeconds,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String programDayId,
                required String exerciseId,
                required int orderIndex,
                Value<int?> targetSets = const Value.absent(),
                Value<int?> targetRepsMin = const Value.absent(),
                Value<int?> targetRepsMax = const Value.absent(),
                Value<int?> targetLoadGrams = const Value.absent(),
                Value<int?> restSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlannedExercisesCompanion.insert(
                id: id,
                programDayId: programDayId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                targetSets: targetSets,
                targetRepsMin: targetRepsMin,
                targetRepsMax: targetRepsMax,
                targetLoadGrams: targetLoadGrams,
                restSeconds: restSeconds,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlannedExercisesTable, PlannedExercise>(table),
                  $$PlannedExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({programDayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (programDayId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.programDayId,
                                referencedTable:
                                    $$PlannedExercisesTableReferences
                                        ._programDayIdTable(db),
                                referencedColumn:
                                    $$PlannedExercisesTableReferences
                                        ._programDayIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlannedExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlannedExercisesTable,
      PlannedExercise,
      $$PlannedExercisesTableFilterComposer,
      $$PlannedExercisesTableOrderingComposer,
      $$PlannedExercisesTableAnnotationComposer,
      $$PlannedExercisesTableCreateCompanionBuilder,
      $$PlannedExercisesTableUpdateCompanionBuilder,
      (PlannedExercise, $$PlannedExercisesTableReferences),
      PlannedExercise,
      PrefetchHooks Function({bool programDayId})
    >;
typedef $$RotationStatesTableCreateCompanionBuilder =
    RotationStatesCompanion Function({
      required String programId,
      required int nextDayIndex,
      Value<String?> lastCompletionEventId,
      Value<int> rowid,
    });
typedef $$RotationStatesTableUpdateCompanionBuilder =
    RotationStatesCompanion Function({
      Value<String> programId,
      Value<int> nextDayIndex,
      Value<String?> lastCompletionEventId,
      Value<int> rowid,
    });

final class $$RotationStatesTableReferences
    extends BaseReferences<_$AppDatabase, $RotationStatesTable, RotationState> {
  $$RotationStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProgramsTable _programIdTable(_$AppDatabase db) =>
      db.programs.createAlias('rotation_states__program_id__programs__id');

  $$ProgramsTableProcessedTableManager get programId {
    final $_column = $_itemColumn<String>('program_id')!;

    final manager = $$ProgramsTableTableManager(
      $_db,
      $_db.programs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RotationStatesTableFilterComposer
    extends Composer<_$AppDatabase, $RotationStatesTable> {
  $$RotationStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get nextDayIndex => $composableBuilder(
    column: $table.nextDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCompletionEventId => $composableBuilder(
    column: $table.lastCompletionEventId,
    builder: (column) => ColumnFilters(column),
  );

  $$ProgramsTableFilterComposer get programId {
    final $$ProgramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableFilterComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RotationStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $RotationStatesTable> {
  $$RotationStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get nextDayIndex => $composableBuilder(
    column: $table.nextDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCompletionEventId => $composableBuilder(
    column: $table.lastCompletionEventId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProgramsTableOrderingComposer get programId {
    final $$ProgramsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableOrderingComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RotationStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RotationStatesTable> {
  $$RotationStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get nextDayIndex => $composableBuilder(
    column: $table.nextDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastCompletionEventId => $composableBuilder(
    column: $table.lastCompletionEventId,
    builder: (column) => column,
  );

  $$ProgramsTableAnnotationComposer get programId {
    final $$ProgramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableAnnotationComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RotationStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RotationStatesTable,
          RotationState,
          $$RotationStatesTableFilterComposer,
          $$RotationStatesTableOrderingComposer,
          $$RotationStatesTableAnnotationComposer,
          $$RotationStatesTableCreateCompanionBuilder,
          $$RotationStatesTableUpdateCompanionBuilder,
          (RotationState, $$RotationStatesTableReferences),
          RotationState,
          PrefetchHooks Function({bool programId})
        > {
  $$RotationStatesTableTableManager(
    _$AppDatabase db,
    $RotationStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RotationStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RotationStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RotationStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> programId = const Value.absent(),
                Value<int> nextDayIndex = const Value.absent(),
                Value<String?> lastCompletionEventId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RotationStatesCompanion(
                programId: programId,
                nextDayIndex: nextDayIndex,
                lastCompletionEventId: lastCompletionEventId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String programId,
                required int nextDayIndex,
                Value<String?> lastCompletionEventId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RotationStatesCompanion.insert(
                programId: programId,
                nextDayIndex: nextDayIndex,
                lastCompletionEventId: lastCompletionEventId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RotationStatesTable, RotationState>(table),
                  $$RotationStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({programId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (programId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.programId,
                                referencedTable: $$RotationStatesTableReferences
                                    ._programIdTable(db),
                                referencedColumn:
                                    $$RotationStatesTableReferences
                                        ._programIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RotationStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RotationStatesTable,
      RotationState,
      $$RotationStatesTableFilterComposer,
      $$RotationStatesTableOrderingComposer,
      $$RotationStatesTableAnnotationComposer,
      $$RotationStatesTableCreateCompanionBuilder,
      $$RotationStatesTableUpdateCompanionBuilder,
      (RotationState, $$RotationStatesTableReferences),
      RotationState,
      PrefetchHooks Function({bool programId})
    >;
typedef $$WeekdayAssignmentsTableCreateCompanionBuilder =
    WeekdayAssignmentsCompanion Function({
      required String id,
      required String programId,
      required int weekday,
      required String assignmentType,
      Value<String?> programDayId,
      Value<int> rowid,
    });
typedef $$WeekdayAssignmentsTableUpdateCompanionBuilder =
    WeekdayAssignmentsCompanion Function({
      Value<String> id,
      Value<String> programId,
      Value<int> weekday,
      Value<String> assignmentType,
      Value<String?> programDayId,
      Value<int> rowid,
    });

final class $$WeekdayAssignmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeekdayAssignmentsTable,
          WeekdayAssignment
        > {
  $$WeekdayAssignmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProgramsTable _programIdTable(_$AppDatabase db) =>
      db.programs.createAlias('weekday_assignments__program_id__programs__id');

  $$ProgramsTableProcessedTableManager get programId {
    final $_column = $_itemColumn<String>('program_id')!;

    final manager = $$ProgramsTableTableManager(
      $_db,
      $_db.programs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProgramDaysTable _programDayIdTable(_$AppDatabase db) => db
      .programDays
      .createAlias('weekday_assignments__program_day_id__program_days__id');

  $$ProgramDaysTableProcessedTableManager? get programDayId {
    final $_column = $_itemColumn<String>('program_day_id');
    if ($_column == null) return null;
    final manager = $$ProgramDaysTableTableManager(
      $_db,
      $_db.programDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeekdayAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $WeekdayAssignmentsTable> {
  $$WeekdayAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignmentType => $composableBuilder(
    column: $table.assignmentType,
    builder: (column) => ColumnFilters(column),
  );

  $$ProgramsTableFilterComposer get programId {
    final $$ProgramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableFilterComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProgramDaysTableFilterComposer get programDayId {
    final $$ProgramDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableFilterComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeekdayAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeekdayAssignmentsTable> {
  $$WeekdayAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignmentType => $composableBuilder(
    column: $table.assignmentType,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProgramsTableOrderingComposer get programId {
    final $$ProgramsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableOrderingComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProgramDaysTableOrderingComposer get programDayId {
    final $$ProgramDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableOrderingComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeekdayAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeekdayAssignmentsTable> {
  $$WeekdayAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get assignmentType => $composableBuilder(
    column: $table.assignmentType,
    builder: (column) => column,
  );

  $$ProgramsTableAnnotationComposer get programId {
    final $$ProgramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableAnnotationComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProgramDaysTableAnnotationComposer get programDayId {
    final $$ProgramDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeekdayAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeekdayAssignmentsTable,
          WeekdayAssignment,
          $$WeekdayAssignmentsTableFilterComposer,
          $$WeekdayAssignmentsTableOrderingComposer,
          $$WeekdayAssignmentsTableAnnotationComposer,
          $$WeekdayAssignmentsTableCreateCompanionBuilder,
          $$WeekdayAssignmentsTableUpdateCompanionBuilder,
          (WeekdayAssignment, $$WeekdayAssignmentsTableReferences),
          WeekdayAssignment,
          PrefetchHooks Function({bool programId, bool programDayId})
        > {
  $$WeekdayAssignmentsTableTableManager(
    _$AppDatabase db,
    $WeekdayAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeekdayAssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeekdayAssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeekdayAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> programId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<String> assignmentType = const Value.absent(),
                Value<String?> programDayId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeekdayAssignmentsCompanion(
                id: id,
                programId: programId,
                weekday: weekday,
                assignmentType: assignmentType,
                programDayId: programDayId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String programId,
                required int weekday,
                required String assignmentType,
                Value<String?> programDayId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeekdayAssignmentsCompanion.insert(
                id: id,
                programId: programId,
                weekday: weekday,
                assignmentType: assignmentType,
                programDayId: programDayId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeekdayAssignmentsTable, WeekdayAssignment>(
                    table,
                  ),
                  $$WeekdayAssignmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({programId = false, programDayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (programId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.programId,
                                referencedTable:
                                    $$WeekdayAssignmentsTableReferences
                                        ._programIdTable(db),
                                referencedColumn:
                                    $$WeekdayAssignmentsTableReferences
                                        ._programIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (programDayId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.programDayId,
                                referencedTable:
                                    $$WeekdayAssignmentsTableReferences
                                        ._programDayIdTable(db),
                                referencedColumn:
                                    $$WeekdayAssignmentsTableReferences
                                        ._programDayIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeekdayAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeekdayAssignmentsTable,
      WeekdayAssignment,
      $$WeekdayAssignmentsTableFilterComposer,
      $$WeekdayAssignmentsTableOrderingComposer,
      $$WeekdayAssignmentsTableAnnotationComposer,
      $$WeekdayAssignmentsTableCreateCompanionBuilder,
      $$WeekdayAssignmentsTableUpdateCompanionBuilder,
      (WeekdayAssignment, $$WeekdayAssignmentsTableReferences),
      WeekdayAssignment,
      PrefetchHooks Function({bool programId, bool programDayId})
    >;
typedef $$BodyWeightEntriesTableCreateCompanionBuilder =
    BodyWeightEntriesCompanion Function({
      required String id,
      required int weightGrams,
      required DateTime measuredAt,
      required String measuredDate,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BodyWeightEntriesTableUpdateCompanionBuilder =
    BodyWeightEntriesCompanion Function({
      Value<String> id,
      Value<int> weightGrams,
      Value<DateTime> measuredAt,
      Value<String> measuredDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BodyWeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BodyWeightEntriesTable> {
  $$BodyWeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measuredDate => $composableBuilder(
    column: $table.measuredDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyWeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyWeightEntriesTable> {
  $$BodyWeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measuredDate => $composableBuilder(
    column: $table.measuredDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyWeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyWeightEntriesTable> {
  $$BodyWeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measuredDate => $composableBuilder(
    column: $table.measuredDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BodyWeightEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyWeightEntriesTable,
          BodyWeightEntry,
          $$BodyWeightEntriesTableFilterComposer,
          $$BodyWeightEntriesTableOrderingComposer,
          $$BodyWeightEntriesTableAnnotationComposer,
          $$BodyWeightEntriesTableCreateCompanionBuilder,
          $$BodyWeightEntriesTableUpdateCompanionBuilder,
          (
            BodyWeightEntry,
            BaseReferences<
              _$AppDatabase,
              $BodyWeightEntriesTable,
              BodyWeightEntry
            >,
          ),
          BodyWeightEntry,
          PrefetchHooks Function()
        > {
  $$BodyWeightEntriesTableTableManager(
    _$AppDatabase db,
    $BodyWeightEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyWeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyWeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyWeightEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> weightGrams = const Value.absent(),
                Value<DateTime> measuredAt = const Value.absent(),
                Value<String> measuredDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyWeightEntriesCompanion(
                id: id,
                weightGrams: weightGrams,
                measuredAt: measuredAt,
                measuredDate: measuredDate,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int weightGrams,
                required DateTime measuredAt,
                required String measuredDate,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BodyWeightEntriesCompanion.insert(
                id: id,
                weightGrams: weightGrams,
                measuredAt: measuredAt,
                measuredDate: measuredDate,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyWeightEntriesTable, BodyWeightEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BodyWeightEntriesTable,
                    BodyWeightEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyWeightEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyWeightEntriesTable,
      BodyWeightEntry,
      $$BodyWeightEntriesTableFilterComposer,
      $$BodyWeightEntriesTableOrderingComposer,
      $$BodyWeightEntriesTableAnnotationComposer,
      $$BodyWeightEntriesTableCreateCompanionBuilder,
      $$BodyWeightEntriesTableUpdateCompanionBuilder,
      (
        BodyWeightEntry,
        BaseReferences<_$AppDatabase, $BodyWeightEntriesTable, BodyWeightEntry>,
      ),
      BodyWeightEntry,
      PrefetchHooks Function()
    >;
typedef $$UserProfileTableCreateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int?> heightCm,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserProfileTableUpdateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int?> heightCm,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTable,
          UserProfileData,
          $$UserProfileTableFilterComposer,
          $$UserProfileTableOrderingComposer,
          $$UserProfileTableAnnotationComposer,
          $$UserProfileTableCreateCompanionBuilder,
          $$UserProfileTableUpdateCompanionBuilder,
          (
            UserProfileData,
            BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
          ),
          UserProfileData,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int?> heightCm = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfileCompanion(
                heightCm: heightCm,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int?> heightCm = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserProfileCompanion.insert(
                heightCm: heightCm,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfileTable, UserProfileData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfileTable,
                    UserProfileData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTable,
      UserProfileData,
      $$UserProfileTableFilterComposer,
      $$UserProfileTableOrderingComposer,
      $$UserProfileTableAnnotationComposer,
      $$UserProfileTableCreateCompanionBuilder,
      $$UserProfileTableUpdateCompanionBuilder,
      (
        UserProfileData,
        BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
      ),
      UserProfileData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$PerformedExercisesTableTableManager get performedExercises =>
      $$PerformedExercisesTableTableManager(_db, _db.performedExercises);
  $$PerformedSetsTableTableManager get performedSets =>
      $$PerformedSetsTableTableManager(_db, _db.performedSets);
  $$CustomExercisesTableTableManager get customExercises =>
      $$CustomExercisesTableTableManager(_db, _db.customExercises);
  $$ProgramsTableTableManager get programs =>
      $$ProgramsTableTableManager(_db, _db.programs);
  $$ProgramDaysTableTableManager get programDays =>
      $$ProgramDaysTableTableManager(_db, _db.programDays);
  $$PlannedExercisesTableTableManager get plannedExercises =>
      $$PlannedExercisesTableTableManager(_db, _db.plannedExercises);
  $$RotationStatesTableTableManager get rotationStates =>
      $$RotationStatesTableTableManager(_db, _db.rotationStates);
  $$WeekdayAssignmentsTableTableManager get weekdayAssignments =>
      $$WeekdayAssignmentsTableTableManager(_db, _db.weekdayAssignments);
  $$BodyWeightEntriesTableTableManager get bodyWeightEntries =>
      $$BodyWeightEntriesTableTableManager(_db, _db.bodyWeightEntries);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
}
