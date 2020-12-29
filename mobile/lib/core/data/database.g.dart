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
  final String username;
  final Role role;
  final String password;
  UserModel(
      {@required this.localId,
      @required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.username,
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
      username: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}username']),
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
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
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
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
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
      username: serializer.fromJson<String>(json['username']),
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
      'username': serializer.toJson<String>(username),
      'role': serializer.toJson<Role>(role),
      'password': serializer.toJson<String>(password),
    };
  }

  UserModel copyWith(
          {int localId,
          String firstName,
          String lastName,
          String email,
          String username,
          Role role,
          String password}) =>
      UserModel(
        localId: localId ?? this.localId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        username: username ?? this.username,
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
          ..write('username: $username, ')
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
                  email.hashCode,
                  $mrjc(username.hashCode,
                      $mrjc(role.hashCode, password.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is UserModel &&
          other.localId == this.localId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.username == this.username &&
          other.role == this.role &&
          other.password == this.password);
}

class UserModelsCompanion extends UpdateCompanion<UserModel> {
  final Value<int> localId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> email;
  final Value<String> username;
  final Value<Role> role;
  final Value<String> password;
  const UserModelsCompanion({
    this.localId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.username = const Value.absent(),
    this.role = const Value.absent(),
    this.password = const Value.absent(),
  });
  UserModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String username,
    @required Role role,
    @required String password,
  })  : firstName = Value(firstName),
        lastName = Value(lastName),
        email = Value(email),
        username = Value(username),
        role = Value(role),
        password = Value(password);
  static Insertable<UserModel> custom({
    Expression<int> localId,
    Expression<String> firstName,
    Expression<String> lastName,
    Expression<String> email,
    Expression<String> username,
    Expression<int> role,
    Expression<String> password,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      if (role != null) 'role': role,
      if (password != null) 'password': password,
    });
  }

  UserModelsCompanion copyWith(
      {Value<int> localId,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> email,
      Value<String> username,
      Value<Role> role,
      Value<String> password}) {
    return UserModelsCompanion(
      localId: localId ?? this.localId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
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
    if (username.present) {
      map['username'] = Variable<String>(username.value);
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
          ..write('username: $username, ')
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

  final VerificationMeta _usernameMeta = const VerificationMeta('username');
  GeneratedTextColumn _username;
  @override
  GeneratedTextColumn get username => _username ??= _constructUsername();
  GeneratedTextColumn _constructUsername() {
    return GeneratedTextColumn(
      'username',
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
      [localId, firstName, lastName, email, username, role, password];
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
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username'], _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
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
  final int schoolId;
  ClassroomModel(
      {@required this.localId,
      @required this.grade,
      @required this.name,
      @required this.tutorId,
      @required this.schoolId});
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
      schoolId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}school_id']),
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
    if (!nullToAbsent || schoolId != null) {
      map['school_id'] = Variable<int>(schoolId);
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
      schoolId: schoolId == null && nullToAbsent
          ? const Value.absent()
          : Value(schoolId),
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
      schoolId: serializer.fromJson<int>(json['school_id']),
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
      'school_id': serializer.toJson<int>(schoolId),
    };
  }

  ClassroomModel copyWith(
          {int localId, int grade, String name, int tutorId, int schoolId}) =>
      ClassroomModel(
        localId: localId ?? this.localId,
        grade: grade ?? this.grade,
        name: name ?? this.name,
        tutorId: tutorId ?? this.tutorId,
        schoolId: schoolId ?? this.schoolId,
      );
  @override
  String toString() {
    return (StringBuffer('ClassroomModel(')
          ..write('localId: $localId, ')
          ..write('grade: $grade, ')
          ..write('name: $name, ')
          ..write('tutorId: $tutorId, ')
          ..write('schoolId: $schoolId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      localId.hashCode,
      $mrjc(grade.hashCode,
          $mrjc(name.hashCode, $mrjc(tutorId.hashCode, schoolId.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ClassroomModel &&
          other.localId == this.localId &&
          other.grade == this.grade &&
          other.name == this.name &&
          other.tutorId == this.tutorId &&
          other.schoolId == this.schoolId);
}

class ClassroomModelsCompanion extends UpdateCompanion<ClassroomModel> {
  final Value<int> localId;
  final Value<int> grade;
  final Value<String> name;
  final Value<int> tutorId;
  final Value<int> schoolId;
  const ClassroomModelsCompanion({
    this.localId = const Value.absent(),
    this.grade = const Value.absent(),
    this.name = const Value.absent(),
    this.tutorId = const Value.absent(),
    this.schoolId = const Value.absent(),
  });
  ClassroomModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required int grade,
    @required String name,
    @required int tutorId,
    @required int schoolId,
  })  : grade = Value(grade),
        name = Value(name),
        tutorId = Value(tutorId),
        schoolId = Value(schoolId);
  static Insertable<ClassroomModel> custom({
    Expression<int> localId,
    Expression<int> grade,
    Expression<String> name,
    Expression<int> tutorId,
    Expression<int> schoolId,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (grade != null) 'grade': grade,
      if (name != null) 'name': name,
      if (tutorId != null) 'tutor_id': tutorId,
      if (schoolId != null) 'school_id': schoolId,
    });
  }

  ClassroomModelsCompanion copyWith(
      {Value<int> localId,
      Value<int> grade,
      Value<String> name,
      Value<int> tutorId,
      Value<int> schoolId}) {
    return ClassroomModelsCompanion(
      localId: localId ?? this.localId,
      grade: grade ?? this.grade,
      name: name ?? this.name,
      tutorId: tutorId ?? this.tutorId,
      schoolId: schoolId ?? this.schoolId,
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
    if (schoolId.present) {
      map['school_id'] = Variable<int>(schoolId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassroomModelsCompanion(')
          ..write('localId: $localId, ')
          ..write('grade: $grade, ')
          ..write('name: $name, ')
          ..write('tutorId: $tutorId, ')
          ..write('schoolId: $schoolId')
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

  final VerificationMeta _schoolIdMeta = const VerificationMeta('schoolId');
  GeneratedIntColumn _schoolId;
  @override
  GeneratedIntColumn get schoolId => _schoolId ??= _constructSchoolId();
  GeneratedIntColumn _constructSchoolId() {
    return GeneratedIntColumn('school_id', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES school_models(local_id)');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [localId, grade, name, tutorId, schoolId];
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
    if (data.containsKey('school_id')) {
      context.handle(_schoolIdMeta,
          schoolId.isAcceptableOrUnknown(data['school_id'], _schoolIdMeta));
    } else if (isInserting) {
      context.missing(_schoolIdMeta);
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

class StudentModel extends DataClass implements Insertable<StudentModel> {
  final int localId;
  final String firstName;
  final String lastName;
  final int classroomId;
  StudentModel(
      {@required this.localId,
      @required this.firstName,
      @required this.lastName,
      @required this.classroomId});
  factory StudentModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return StudentModel(
      localId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}local_id']),
      firstName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}first_name']),
      lastName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_name']),
      classroomId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}classroom_id']),
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
    if (!nullToAbsent || classroomId != null) {
      map['classroom_id'] = Variable<int>(classroomId);
    }
    return map;
  }

  StudentModelsCompanion toCompanion(bool nullToAbsent) {
    return StudentModelsCompanion(
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      classroomId: classroomId == null && nullToAbsent
          ? const Value.absent()
          : Value(classroomId),
    );
  }

  factory StudentModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return StudentModel(
      localId: serializer.fromJson<int>(json['local_id']),
      firstName: serializer.fromJson<String>(json['first_name']),
      lastName: serializer.fromJson<String>(json['last_name']),
      classroomId: serializer.fromJson<int>(json['classroom_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_id': serializer.toJson<int>(localId),
      'first_name': serializer.toJson<String>(firstName),
      'last_name': serializer.toJson<String>(lastName),
      'classroom_id': serializer.toJson<int>(classroomId),
    };
  }

  StudentModel copyWith(
          {int localId, String firstName, String lastName, int classroomId}) =>
      StudentModel(
        localId: localId ?? this.localId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        classroomId: classroomId ?? this.classroomId,
      );
  @override
  String toString() {
    return (StringBuffer('StudentModel(')
          ..write('localId: $localId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('classroomId: $classroomId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      localId.hashCode,
      $mrjc(
          firstName.hashCode, $mrjc(lastName.hashCode, classroomId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is StudentModel &&
          other.localId == this.localId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.classroomId == this.classroomId);
}

class StudentModelsCompanion extends UpdateCompanion<StudentModel> {
  final Value<int> localId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<int> classroomId;
  const StudentModelsCompanion({
    this.localId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.classroomId = const Value.absent(),
  });
  StudentModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required String firstName,
    @required String lastName,
    @required int classroomId,
  })  : firstName = Value(firstName),
        lastName = Value(lastName),
        classroomId = Value(classroomId);
  static Insertable<StudentModel> custom({
    Expression<int> localId,
    Expression<String> firstName,
    Expression<String> lastName,
    Expression<int> classroomId,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (classroomId != null) 'classroom_id': classroomId,
    });
  }

  StudentModelsCompanion copyWith(
      {Value<int> localId,
      Value<String> firstName,
      Value<String> lastName,
      Value<int> classroomId}) {
    return StudentModelsCompanion(
      localId: localId ?? this.localId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      classroomId: classroomId ?? this.classroomId,
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
    if (classroomId.present) {
      map['classroom_id'] = Variable<int>(classroomId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentModelsCompanion(')
          ..write('localId: $localId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('classroomId: $classroomId')
          ..write(')'))
        .toString();
  }
}

class $StudentModelsTable extends StudentModels
    with TableInfo<$StudentModelsTable, StudentModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $StudentModelsTable(this._db, [this._alias]);
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

  final VerificationMeta _classroomIdMeta =
      const VerificationMeta('classroomId');
  GeneratedIntColumn _classroomId;
  @override
  GeneratedIntColumn get classroomId =>
      _classroomId ??= _constructClassroomId();
  GeneratedIntColumn _constructClassroomId() {
    return GeneratedIntColumn('classroom_id', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES classroom_models(local_id)');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [localId, firstName, lastName, classroomId];
  @override
  $StudentModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'student_models';
  @override
  final String actualTableName = 'student_models';
  @override
  VerificationContext validateIntegrity(Insertable<StudentModel> instance,
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
    if (data.containsKey('classroom_id')) {
      context.handle(
          _classroomIdMeta,
          classroomId.isAcceptableOrUnknown(
              data['classroom_id'], _classroomIdMeta));
    } else if (isInserting) {
      context.missing(_classroomIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  StudentModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return StudentModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $StudentModelsTable createAlias(String alias) {
    return $StudentModelsTable(_db, alias);
  }
}

class TextModel extends DataClass implements Insertable<TextModel> {
  final int localId;
  final String title;
  final String body;
  final int classId;
  TextModel(
      {@required this.localId,
      @required this.title,
      @required this.body,
      @required this.classId});
  factory TextModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return TextModel(
      localId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}local_id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      body: stringType.mapFromDatabaseResponse(data['${effectivePrefix}body']),
      classId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}class_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<int>(localId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || classId != null) {
      map['class_id'] = Variable<int>(classId);
    }
    return map;
  }

  TextModelsCompanion toCompanion(bool nullToAbsent) {
    return TextModelsCompanion(
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      classId: classId == null && nullToAbsent
          ? const Value.absent()
          : Value(classId),
    );
  }

  factory TextModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TextModel(
      localId: serializer.fromJson<int>(json['local_id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      classId: serializer.fromJson<int>(json['class_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_id': serializer.toJson<int>(localId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'class_id': serializer.toJson<int>(classId),
    };
  }

  TextModel copyWith({int localId, String title, String body, int classId}) =>
      TextModel(
        localId: localId ?? this.localId,
        title: title ?? this.title,
        body: body ?? this.body,
        classId: classId ?? this.classId,
      );
  @override
  String toString() {
    return (StringBuffer('TextModel(')
          ..write('localId: $localId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('classId: $classId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(localId.hashCode,
      $mrjc(title.hashCode, $mrjc(body.hashCode, classId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TextModel &&
          other.localId == this.localId &&
          other.title == this.title &&
          other.body == this.body &&
          other.classId == this.classId);
}

class TextModelsCompanion extends UpdateCompanion<TextModel> {
  final Value<int> localId;
  final Value<String> title;
  final Value<String> body;
  final Value<int> classId;
  const TextModelsCompanion({
    this.localId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.classId = const Value.absent(),
  });
  TextModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required String title,
    @required String body,
    @required int classId,
  })  : title = Value(title),
        body = Value(body),
        classId = Value(classId);
  static Insertable<TextModel> custom({
    Expression<int> localId,
    Expression<String> title,
    Expression<String> body,
    Expression<int> classId,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (classId != null) 'class_id': classId,
    });
  }

  TextModelsCompanion copyWith(
      {Value<int> localId,
      Value<String> title,
      Value<String> body,
      Value<int> classId}) {
    return TextModelsCompanion(
      localId: localId ?? this.localId,
      title: title ?? this.title,
      body: body ?? this.body,
      classId: classId ?? this.classId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<int>(classId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TextModelsCompanion(')
          ..write('localId: $localId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('classId: $classId')
          ..write(')'))
        .toString();
  }
}

class $TextModelsTable extends TextModels
    with TableInfo<$TextModelsTable, TextModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $TextModelsTable(this._db, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  GeneratedIntColumn _localId;
  @override
  GeneratedIntColumn get localId => _localId ??= _constructLocalId();
  GeneratedIntColumn _constructLocalId() {
    return GeneratedIntColumn('local_id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bodyMeta = const VerificationMeta('body');
  GeneratedTextColumn _body;
  @override
  GeneratedTextColumn get body => _body ??= _constructBody();
  GeneratedTextColumn _constructBody() {
    return GeneratedTextColumn(
      'body',
      $tableName,
      false,
    );
  }

  final VerificationMeta _classIdMeta = const VerificationMeta('classId');
  GeneratedIntColumn _classId;
  @override
  GeneratedIntColumn get classId => _classId ??= _constructClassId();
  GeneratedIntColumn _constructClassId() {
    return GeneratedIntColumn('class_id', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES classroom_models(local_id)');
  }

  @override
  List<GeneratedColumn> get $columns => [localId, title, body, classId];
  @override
  $TextModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'text_models';
  @override
  final String actualTableName = 'text_models';
  @override
  VerificationContext validateIntegrity(Insertable<TextModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id'], _localIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body'], _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id'], _classIdMeta));
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  TextModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TextModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TextModelsTable createAlias(String alias) {
    return $TextModelsTable(_db, alias);
  }
}

class SchoolModel extends DataClass implements Insertable<SchoolModel> {
  final int localId;
  final int zipCode;
  final Modality modality;
  final String state;
  final String city;
  final String neighborhood;
  final String name;
  final int userId;
  SchoolModel(
      {@required this.localId,
      @required this.zipCode,
      @required this.modality,
      @required this.state,
      @required this.city,
      @required this.neighborhood,
      @required this.name,
      @required this.userId});
  factory SchoolModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return SchoolModel(
      localId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}local_id']),
      zipCode:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}zip_code']),
      modality: $SchoolModelsTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}modality'])),
      state:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}state']),
      city: stringType.mapFromDatabaseResponse(data['${effectivePrefix}city']),
      neighborhood: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}neighborhood']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      userId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<int>(localId);
    }
    if (!nullToAbsent || zipCode != null) {
      map['zip_code'] = Variable<int>(zipCode);
    }
    if (!nullToAbsent || modality != null) {
      final converter = $SchoolModelsTable.$converter0;
      map['modality'] = Variable<int>(converter.mapToSql(modality));
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || neighborhood != null) {
      map['neighborhood'] = Variable<String>(neighborhood);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    return map;
  }

  SchoolModelsCompanion toCompanion(bool nullToAbsent) {
    return SchoolModelsCompanion(
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      zipCode: zipCode == null && nullToAbsent
          ? const Value.absent()
          : Value(zipCode),
      modality: modality == null && nullToAbsent
          ? const Value.absent()
          : Value(modality),
      state:
          state == null && nullToAbsent ? const Value.absent() : Value(state),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      neighborhood: neighborhood == null && nullToAbsent
          ? const Value.absent()
          : Value(neighborhood),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
    );
  }

  factory SchoolModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SchoolModel(
      localId: serializer.fromJson<int>(json['local_id']),
      zipCode: serializer.fromJson<int>(json['zip_code']),
      modality: serializer.fromJson<Modality>(json['modality']),
      state: serializer.fromJson<String>(json['state']),
      city: serializer.fromJson<String>(json['city']),
      neighborhood: serializer.fromJson<String>(json['neighborhood']),
      name: serializer.fromJson<String>(json['name']),
      userId: serializer.fromJson<int>(json['user_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_id': serializer.toJson<int>(localId),
      'zip_code': serializer.toJson<int>(zipCode),
      'modality': serializer.toJson<Modality>(modality),
      'state': serializer.toJson<String>(state),
      'city': serializer.toJson<String>(city),
      'neighborhood': serializer.toJson<String>(neighborhood),
      'name': serializer.toJson<String>(name),
      'user_id': serializer.toJson<int>(userId),
    };
  }

  SchoolModel copyWith(
          {int localId,
          int zipCode,
          Modality modality,
          String state,
          String city,
          String neighborhood,
          String name,
          int userId}) =>
      SchoolModel(
        localId: localId ?? this.localId,
        zipCode: zipCode ?? this.zipCode,
        modality: modality ?? this.modality,
        state: state ?? this.state,
        city: city ?? this.city,
        neighborhood: neighborhood ?? this.neighborhood,
        name: name ?? this.name,
        userId: userId ?? this.userId,
      );
  @override
  String toString() {
    return (StringBuffer('SchoolModel(')
          ..write('localId: $localId, ')
          ..write('zipCode: $zipCode, ')
          ..write('modality: $modality, ')
          ..write('state: $state, ')
          ..write('city: $city, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('name: $name, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      localId.hashCode,
      $mrjc(
          zipCode.hashCode,
          $mrjc(
              modality.hashCode,
              $mrjc(
                  state.hashCode,
                  $mrjc(
                      city.hashCode,
                      $mrjc(neighborhood.hashCode,
                          $mrjc(name.hashCode, userId.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SchoolModel &&
          other.localId == this.localId &&
          other.zipCode == this.zipCode &&
          other.modality == this.modality &&
          other.state == this.state &&
          other.city == this.city &&
          other.neighborhood == this.neighborhood &&
          other.name == this.name &&
          other.userId == this.userId);
}

class SchoolModelsCompanion extends UpdateCompanion<SchoolModel> {
  final Value<int> localId;
  final Value<int> zipCode;
  final Value<Modality> modality;
  final Value<String> state;
  final Value<String> city;
  final Value<String> neighborhood;
  final Value<String> name;
  final Value<int> userId;
  const SchoolModelsCompanion({
    this.localId = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.modality = const Value.absent(),
    this.state = const Value.absent(),
    this.city = const Value.absent(),
    this.neighborhood = const Value.absent(),
    this.name = const Value.absent(),
    this.userId = const Value.absent(),
  });
  SchoolModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required int zipCode,
    @required Modality modality,
    @required String state,
    @required String city,
    @required String neighborhood,
    @required String name,
    @required int userId,
  })  : zipCode = Value(zipCode),
        modality = Value(modality),
        state = Value(state),
        city = Value(city),
        neighborhood = Value(neighborhood),
        name = Value(name),
        userId = Value(userId);
  static Insertable<SchoolModel> custom({
    Expression<int> localId,
    Expression<int> zipCode,
    Expression<int> modality,
    Expression<String> state,
    Expression<String> city,
    Expression<String> neighborhood,
    Expression<String> name,
    Expression<int> userId,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (zipCode != null) 'zip_code': zipCode,
      if (modality != null) 'modality': modality,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (neighborhood != null) 'neighborhood': neighborhood,
      if (name != null) 'name': name,
      if (userId != null) 'user_id': userId,
    });
  }

  SchoolModelsCompanion copyWith(
      {Value<int> localId,
      Value<int> zipCode,
      Value<Modality> modality,
      Value<String> state,
      Value<String> city,
      Value<String> neighborhood,
      Value<String> name,
      Value<int> userId}) {
    return SchoolModelsCompanion(
      localId: localId ?? this.localId,
      zipCode: zipCode ?? this.zipCode,
      modality: modality ?? this.modality,
      state: state ?? this.state,
      city: city ?? this.city,
      neighborhood: neighborhood ?? this.neighborhood,
      name: name ?? this.name,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (zipCode.present) {
      map['zip_code'] = Variable<int>(zipCode.value);
    }
    if (modality.present) {
      final converter = $SchoolModelsTable.$converter0;
      map['modality'] = Variable<int>(converter.mapToSql(modality.value));
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (neighborhood.present) {
      map['neighborhood'] = Variable<String>(neighborhood.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolModelsCompanion(')
          ..write('localId: $localId, ')
          ..write('zipCode: $zipCode, ')
          ..write('modality: $modality, ')
          ..write('state: $state, ')
          ..write('city: $city, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('name: $name, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $SchoolModelsTable extends SchoolModels
    with TableInfo<$SchoolModelsTable, SchoolModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $SchoolModelsTable(this._db, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  GeneratedIntColumn _localId;
  @override
  GeneratedIntColumn get localId => _localId ??= _constructLocalId();
  GeneratedIntColumn _constructLocalId() {
    return GeneratedIntColumn('local_id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _zipCodeMeta = const VerificationMeta('zipCode');
  GeneratedIntColumn _zipCode;
  @override
  GeneratedIntColumn get zipCode => _zipCode ??= _constructZipCode();
  GeneratedIntColumn _constructZipCode() {
    return GeneratedIntColumn(
      'zip_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _modalityMeta = const VerificationMeta('modality');
  GeneratedIntColumn _modality;
  @override
  GeneratedIntColumn get modality => _modality ??= _constructModality();
  GeneratedIntColumn _constructModality() {
    return GeneratedIntColumn(
      'modality',
      $tableName,
      false,
    );
  }

  final VerificationMeta _stateMeta = const VerificationMeta('state');
  GeneratedTextColumn _state;
  @override
  GeneratedTextColumn get state => _state ??= _constructState();
  GeneratedTextColumn _constructState() {
    return GeneratedTextColumn(
      'state',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cityMeta = const VerificationMeta('city');
  GeneratedTextColumn _city;
  @override
  GeneratedTextColumn get city => _city ??= _constructCity();
  GeneratedTextColumn _constructCity() {
    return GeneratedTextColumn(
      'city',
      $tableName,
      false,
    );
  }

  final VerificationMeta _neighborhoodMeta =
      const VerificationMeta('neighborhood');
  GeneratedTextColumn _neighborhood;
  @override
  GeneratedTextColumn get neighborhood =>
      _neighborhood ??= _constructNeighborhood();
  GeneratedTextColumn _constructNeighborhood() {
    return GeneratedTextColumn(
      'neighborhood',
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

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedIntColumn _userId;
  @override
  GeneratedIntColumn get userId => _userId ??= _constructUserId();
  GeneratedIntColumn _constructUserId() {
    return GeneratedIntColumn('user_id', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES user_models(local_id)');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [localId, zipCode, modality, state, city, neighborhood, name, userId];
  @override
  $SchoolModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'school_models';
  @override
  final String actualTableName = 'school_models';
  @override
  VerificationContext validateIntegrity(Insertable<SchoolModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id'], _localIdMeta));
    }
    if (data.containsKey('zip_code')) {
      context.handle(_zipCodeMeta,
          zipCode.isAcceptableOrUnknown(data['zip_code'], _zipCodeMeta));
    } else if (isInserting) {
      context.missing(_zipCodeMeta);
    }
    context.handle(_modalityMeta, const VerificationResult.success());
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state'], _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city'], _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('neighborhood')) {
      context.handle(
          _neighborhoodMeta,
          neighborhood.isAcceptableOrUnknown(
              data['neighborhood'], _neighborhoodMeta));
    } else if (isInserting) {
      context.missing(_neighborhoodMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  SchoolModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SchoolModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SchoolModelsTable createAlias(String alias) {
    return $SchoolModelsTable(_db, alias);
  }

  static TypeConverter<Modality, int> $converter0 =
      const EnumIndexConverter<Modality>(Modality.values);
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $UserModelsTable _userModels;
  $UserModelsTable get userModels => _userModels ??= $UserModelsTable(this);
  $ClassroomModelsTable _classroomModels;
  $ClassroomModelsTable get classroomModels =>
      _classroomModels ??= $ClassroomModelsTable(this);
  $StudentModelsTable _studentModels;
  $StudentModelsTable get studentModels =>
      _studentModels ??= $StudentModelsTable(this);
  $TextModelsTable _textModels;
  $TextModelsTable get textModels => _textModels ??= $TextModelsTable(this);
  $SchoolModelsTable _schoolModels;
  $SchoolModelsTable get schoolModels =>
      _schoolModels ??= $SchoolModelsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [userModels, classroomModels, studentModels, textModels, schoolModels];
}
