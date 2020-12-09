// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class UserModel extends DataClass implements Insertable<UserModel> {
  final int localId;
  final String firstName;
  final String lastName;
  final String email;
  final Role role;
  final String password;
  UserModel(
      {@required this.localId,
      @required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.role,
      @required this.password});
  factory UserModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return UserModel(
      localId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}local_id']),
      firstName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}first_name']),
      lastName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_name']),
      email:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}email']),
      role: $UserModelsTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}role'])),
      password: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<int>(localId);
    }
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || role != null) {
      final converter = $UserModelsTable.$converter0;
      map['role'] = Variable<int>(converter.mapToSql(role));
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    return map;
  }

  UserModelsCompanion toCompanion(bool nullToAbsent) {
    return UserModelsCompanion(
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return UserModel(
      localId: serializer.fromJson<int>(json['local_id']),
      firstName: serializer.fromJson<String>(json['first_name']),
      lastName: serializer.fromJson<String>(json['last_name']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<Role>(json['role']),
      password: serializer.fromJson<String>(json['password']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_id': serializer.toJson<int>(localId),
      'first_name': serializer.toJson<String>(firstName),
      'last_name': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<Role>(role),
      'password': serializer.toJson<String>(password),
    };
  }

  UserModel copyWith(
          {int localId,
          String firstName,
          String lastName,
          String email,
          Role role,
          String password}) =>
      UserModel(
        localId: localId ?? this.localId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        role: role ?? this.role,
        password: password ?? this.password,
      );
  @override
  String toString() {
    return (StringBuffer('UserModel(')
          ..write('localId: $localId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      localId.hashCode,
      $mrjc(
          firstName.hashCode,
          $mrjc(
              lastName.hashCode,
              $mrjc(
                  email.hashCode, $mrjc(role.hashCode, password.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is UserModel &&
          other.localId == this.localId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.role == this.role &&
          other.password == this.password);
}

class UserModelsCompanion extends UpdateCompanion<UserModel> {
  final Value<int> localId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> email;
  final Value<Role> role;
  final Value<String> password;
  const UserModelsCompanion({
    this.localId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.password = const Value.absent(),
  });
  UserModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required String firstName,
    @required String lastName,
    @required String email,
    @required Role role,
    @required String password,
  })  : firstName = Value(firstName),
        lastName = Value(lastName),
        email = Value(email),
        role = Value(role),
        password = Value(password);
  static Insertable<UserModel> custom({
    Expression<int> localId,
    Expression<String> firstName,
    Expression<String> lastName,
    Expression<String> email,
    Expression<int> role,
    Expression<String> password,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (password != null) 'password': password,
    });
  }

  UserModelsCompanion copyWith(
      {Value<int> localId,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> email,
      Value<Role> role,
      Value<String> password}) {
    return UserModelsCompanion(
      localId: localId ?? this.localId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      password: password ?? this.password,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      final converter = $UserModelsTable.$converter0;
      map['role'] = Variable<int>(converter.mapToSql(role.value));
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserModelsCompanion(')
          ..write('localId: $localId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }
}

class $UserModelsTable extends UserModels
    with TableInfo<$UserModelsTable, UserModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $UserModelsTable(this._db, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  GeneratedIntColumn _localId;
  @override
  GeneratedIntColumn get localId => _localId ??= _constructLocalId();
  GeneratedIntColumn _constructLocalId() {
    return GeneratedIntColumn('local_id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _firstNameMeta = const VerificationMeta('firstName');
  GeneratedTextColumn _firstName;
  @override
  GeneratedTextColumn get firstName => _firstName ??= _constructFirstName();
  GeneratedTextColumn _constructFirstName() {
    return GeneratedTextColumn(
      'first_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastNameMeta = const VerificationMeta('lastName');
  GeneratedTextColumn _lastName;
  @override
  GeneratedTextColumn get lastName => _lastName ??= _constructLastName();
  GeneratedTextColumn _constructLastName() {
    return GeneratedTextColumn(
      'last_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _emailMeta = const VerificationMeta('email');
  GeneratedTextColumn _email;
  @override
  GeneratedTextColumn get email => _email ??= _constructEmail();
  GeneratedTextColumn _constructEmail() {
    return GeneratedTextColumn(
      'email',
      $tableName,
      false,
    );
  }

  final VerificationMeta _roleMeta = const VerificationMeta('role');
  GeneratedIntColumn _role;
  @override
  GeneratedIntColumn get role => _role ??= _constructRole();
  GeneratedIntColumn _constructRole() {
    return GeneratedIntColumn(
      'role',
      $tableName,
      false,
    );
  }

  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  GeneratedTextColumn _password;
  @override
  GeneratedTextColumn get password => _password ??= _constructPassword();
  GeneratedTextColumn _constructPassword() {
    return GeneratedTextColumn(
      'password',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [localId, firstName, lastName, email, role, password];
  @override
  $UserModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'user_models';
  @override
  final String actualTableName = 'user_models';
  @override
  VerificationContext validateIntegrity(Insertable<UserModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id'], _localIdMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name'], _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name'], _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email'], _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    context.handle(_roleMeta, const VerificationResult.success());
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password'], _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  UserModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return UserModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $UserModelsTable createAlias(String alias) {
    return $UserModelsTable(_db, alias);
  }

  static TypeConverter<Role, int> $converter0 =
      const EnumIndexConverter<Role>(Role.values);
}

class ClassroomModel extends DataClass implements Insertable<ClassroomModel> {
  final int localId;
  final int grade;
  final String name;
  final int tutorId;
  ClassroomModel(
      {@required this.localId,
      @required this.grade,
      @required this.name,
      @required this.tutorId});
  factory ClassroomModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return ClassroomModel(
      localId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}local_id']),
      grade: intType.mapFromDatabaseResponse(data['${effectivePrefix}grade']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      tutorId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}tutor_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<int>(localId);
    }
    if (!nullToAbsent || grade != null) {
      map['grade'] = Variable<int>(grade);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || tutorId != null) {
      map['tutor_id'] = Variable<int>(tutorId);
    }
    return map;
  }

  ClassroomModelsCompanion toCompanion(bool nullToAbsent) {
    return ClassroomModelsCompanion(
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      grade:
          grade == null && nullToAbsent ? const Value.absent() : Value(grade),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      tutorId: tutorId == null && nullToAbsent
          ? const Value.absent()
          : Value(tutorId),
    );
  }

  factory ClassroomModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ClassroomModel(
      localId: serializer.fromJson<int>(json['local_id']),
      grade: serializer.fromJson<int>(json['grade']),
      name: serializer.fromJson<String>(json['name']),
      tutorId: serializer.fromJson<int>(json['tutor_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_id': serializer.toJson<int>(localId),
      'grade': serializer.toJson<int>(grade),
      'name': serializer.toJson<String>(name),
      'tutor_id': serializer.toJson<int>(tutorId),
    };
  }

  ClassroomModel copyWith({int localId, int grade, String name, int tutorId}) =>
      ClassroomModel(
        localId: localId ?? this.localId,
        grade: grade ?? this.grade,
        name: name ?? this.name,
        tutorId: tutorId ?? this.tutorId,
      );
  @override
  String toString() {
    return (StringBuffer('ClassroomModel(')
          ..write('localId: $localId, ')
          ..write('grade: $grade, ')
          ..write('name: $name, ')
          ..write('tutorId: $tutorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(localId.hashCode,
      $mrjc(grade.hashCode, $mrjc(name.hashCode, tutorId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ClassroomModel &&
          other.localId == this.localId &&
          other.grade == this.grade &&
          other.name == this.name &&
          other.tutorId == this.tutorId);
}

class ClassroomModelsCompanion extends UpdateCompanion<ClassroomModel> {
  final Value<int> localId;
  final Value<int> grade;
  final Value<String> name;
  final Value<int> tutorId;
  const ClassroomModelsCompanion({
    this.localId = const Value.absent(),
    this.grade = const Value.absent(),
    this.name = const Value.absent(),
    this.tutorId = const Value.absent(),
  });
  ClassroomModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required int grade,
    @required String name,
    @required int tutorId,
  })  : grade = Value(grade),
        name = Value(name),
        tutorId = Value(tutorId);
  static Insertable<ClassroomModel> custom({
    Expression<int> localId,
    Expression<int> grade,
    Expression<String> name,
    Expression<int> tutorId,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (grade != null) 'grade': grade,
      if (name != null) 'name': name,
      if (tutorId != null) 'tutor_id': tutorId,
    });
  }

  ClassroomModelsCompanion copyWith(
      {Value<int> localId,
      Value<int> grade,
      Value<String> name,
      Value<int> tutorId}) {
    return ClassroomModelsCompanion(
      localId: localId ?? this.localId,
      grade: grade ?? this.grade,
      name: name ?? this.name,
      tutorId: tutorId ?? this.tutorId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (tutorId.present) {
      map['tutor_id'] = Variable<int>(tutorId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassroomModelsCompanion(')
          ..write('localId: $localId, ')
          ..write('grade: $grade, ')
          ..write('name: $name, ')
          ..write('tutorId: $tutorId')
          ..write(')'))
        .toString();
  }
}

class $ClassroomModelsTable extends ClassroomModels
    with TableInfo<$ClassroomModelsTable, ClassroomModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $ClassroomModelsTable(this._db, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  GeneratedIntColumn _localId;
  @override
  GeneratedIntColumn get localId => _localId ??= _constructLocalId();
  GeneratedIntColumn _constructLocalId() {
    return GeneratedIntColumn('local_id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _gradeMeta = const VerificationMeta('grade');
  GeneratedIntColumn _grade;
  @override
  GeneratedIntColumn get grade => _grade ??= _constructGrade();
  GeneratedIntColumn _constructGrade() {
    return GeneratedIntColumn(
      'grade',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _tutorIdMeta = const VerificationMeta('tutorId');
  GeneratedIntColumn _tutorId;
  @override
  GeneratedIntColumn get tutorId => _tutorId ??= _constructTutorId();
  GeneratedIntColumn _constructTutorId() {
    return GeneratedIntColumn('tutor_id', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES user_models(local_id)');
  }

  @override
  List<GeneratedColumn> get $columns => [localId, grade, name, tutorId];
  @override
  $ClassroomModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'classroom_models';
  @override
  final String actualTableName = 'classroom_models';
  @override
  VerificationContext validateIntegrity(Insertable<ClassroomModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id'], _localIdMeta));
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade'], _gradeMeta));
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('tutor_id')) {
      context.handle(_tutorIdMeta,
          tutorId.isAcceptableOrUnknown(data['tutor_id'], _tutorIdMeta));
    } else if (isInserting) {
      context.missing(_tutorIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  ClassroomModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ClassroomModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ClassroomModelsTable createAlias(String alias) {
    return $ClassroomModelsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $UserModelsTable _userModels;
  $UserModelsTable get userModels => _userModels ??= $UserModelsTable(this);
  $ClassroomModelsTable _classroomModels;
  $ClassroomModelsTable get classroomModels =>
      _classroomModels ??= $ClassroomModelsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [userModels, classroomModels];
}