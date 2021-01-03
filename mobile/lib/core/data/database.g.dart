// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class UserModel extends DataClass implements Insertable<UserModel> {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final Role role;
  final String password;
  UserModel(
      {@required this.id,
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
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
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
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
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
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
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
      id: serializer.fromJson<int>(json['id']),
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
      'id': serializer.toJson<int>(id),
      'first_name': serializer.toJson<String>(firstName),
      'last_name': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String>(email),
      'username': serializer.toJson<String>(username),
      'role': serializer.toJson<Role>(role),
      'password': serializer.toJson<String>(password),
    };
  }

  UserModel copyWith(
          {int id,
          String firstName,
          String lastName,
          String email,
          String username,
          Role role,
          String password}) =>
      UserModel(
        id: id ?? this.id,
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
          ..write('id: $id, ')
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
      id.hashCode,
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
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.username == this.username &&
          other.role == this.role &&
          other.password == this.password);
}

class UserModelsCompanion extends UpdateCompanion<UserModel> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> email;
  final Value<String> username;
  final Value<Role> role;
  final Value<String> password;
  const UserModelsCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.username = const Value.absent(),
    this.role = const Value.absent(),
    this.password = const Value.absent(),
  });
  UserModelsCompanion.insert({
    this.id = const Value.absent(),
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
    Expression<int> id,
    Expression<String> firstName,
    Expression<String> lastName,
    Expression<String> email,
    Expression<String> username,
    Expression<int> role,
    Expression<String> password,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      if (role != null) 'role': role,
      if (password != null) 'password': password,
    });
  }

  UserModelsCompanion copyWith(
      {Value<int> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> email,
      Value<String> username,
      Value<Role> role,
      Value<String> password}) {
    return UserModelsCompanion(
      id: id ?? this.id,
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
    if (id.present) {
      map['id'] = Variable<int>(id.value);
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
          ..write('id: $id, ')
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
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
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
      [id, firstName, lastName, email, username, role, password];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
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
  Set<GeneratedColumn> get $primaryKey => {id};
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
  final DateTime lastUpdated;
  final DateTime clientLastUpdated;
  final bool deleted;
  final int tutorId;
  ClassroomModel(
      {@required this.localId,
      @required this.grade,
      @required this.name,
      @required this.lastUpdated,
      @required this.clientLastUpdated,
      @required this.deleted,
      @required this.tutorId});
  factory ClassroomModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return ClassroomModel(
      localId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}local_id']),
      grade: intType.mapFromDatabaseResponse(data['${effectivePrefix}grade']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
      clientLastUpdated: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}client_last_updated']),
      deleted:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}deleted']),
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
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    if (!nullToAbsent || clientLastUpdated != null) {
      map['client_last_updated'] = Variable<DateTime>(clientLastUpdated);
    }
    if (!nullToAbsent || deleted != null) {
      map['deleted'] = Variable<bool>(deleted);
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
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
      clientLastUpdated: clientLastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(clientLastUpdated),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
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
      lastUpdated: serializer.fromJson<DateTime>(json['last_updated']),
      clientLastUpdated:
          serializer.fromJson<DateTime>(json['client_last_updated']),
      deleted: serializer.fromJson<bool>(json['deleted']),
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
      'last_updated': serializer.toJson<DateTime>(lastUpdated),
      'client_last_updated': serializer.toJson<DateTime>(clientLastUpdated),
      'deleted': serializer.toJson<bool>(deleted),
      'tutor_id': serializer.toJson<int>(tutorId),
    };
  }

  ClassroomModel copyWith(
          {int localId,
          int grade,
          String name,
          DateTime lastUpdated,
          DateTime clientLastUpdated,
          bool deleted,
          int tutorId}) =>
      ClassroomModel(
        localId: localId ?? this.localId,
        grade: grade ?? this.grade,
        name: name ?? this.name,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        clientLastUpdated: clientLastUpdated ?? this.clientLastUpdated,
        deleted: deleted ?? this.deleted,
        tutorId: tutorId ?? this.tutorId,
      );
  @override
  String toString() {
    return (StringBuffer('ClassroomModel(')
          ..write('localId: $localId, ')
          ..write('grade: $grade, ')
          ..write('name: $name, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('clientLastUpdated: $clientLastUpdated, ')
          ..write('deleted: $deleted, ')
          ..write('tutorId: $tutorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      localId.hashCode,
      $mrjc(
          grade.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  lastUpdated.hashCode,
                  $mrjc(clientLastUpdated.hashCode,
                      $mrjc(deleted.hashCode, tutorId.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ClassroomModel &&
          other.localId == this.localId &&
          other.grade == this.grade &&
          other.name == this.name &&
          other.lastUpdated == this.lastUpdated &&
          other.clientLastUpdated == this.clientLastUpdated &&
          other.deleted == this.deleted &&
          other.tutorId == this.tutorId);
}

class ClassroomModelsCompanion extends UpdateCompanion<ClassroomModel> {
  final Value<int> localId;
  final Value<int> grade;
  final Value<String> name;
  final Value<DateTime> lastUpdated;
  final Value<DateTime> clientLastUpdated;
  final Value<bool> deleted;
  final Value<int> tutorId;
  const ClassroomModelsCompanion({
    this.localId = const Value.absent(),
    this.grade = const Value.absent(),
    this.name = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.clientLastUpdated = const Value.absent(),
    this.deleted = const Value.absent(),
    this.tutorId = const Value.absent(),
  });
  ClassroomModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required int grade,
    @required String name,
    @required DateTime lastUpdated,
    @required DateTime clientLastUpdated,
    @required bool deleted,
    @required int tutorId,
  })  : grade = Value(grade),
        name = Value(name),
        lastUpdated = Value(lastUpdated),
        clientLastUpdated = Value(clientLastUpdated),
        deleted = Value(deleted),
        tutorId = Value(tutorId);
  static Insertable<ClassroomModel> custom({
    Expression<int> localId,
    Expression<int> grade,
    Expression<String> name,
    Expression<DateTime> lastUpdated,
    Expression<DateTime> clientLastUpdated,
    Expression<bool> deleted,
    Expression<int> tutorId,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (grade != null) 'grade': grade,
      if (name != null) 'name': name,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (clientLastUpdated != null) 'client_last_updated': clientLastUpdated,
      if (deleted != null) 'deleted': deleted,
      if (tutorId != null) 'tutor_id': tutorId,
    });
  }

  ClassroomModelsCompanion copyWith(
      {Value<int> localId,
      Value<int> grade,
      Value<String> name,
      Value<DateTime> lastUpdated,
      Value<DateTime> clientLastUpdated,
      Value<bool> deleted,
      Value<int> tutorId}) {
    return ClassroomModelsCompanion(
      localId: localId ?? this.localId,
      grade: grade ?? this.grade,
      name: name ?? this.name,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      clientLastUpdated: clientLastUpdated ?? this.clientLastUpdated,
      deleted: deleted ?? this.deleted,
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
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (clientLastUpdated.present) {
      map['client_last_updated'] = Variable<DateTime>(clientLastUpdated.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
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
          ..write('lastUpdated: $lastUpdated, ')
          ..write('clientLastUpdated: $clientLastUpdated, ')
          ..write('deleted: $deleted, ')
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

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  final VerificationMeta _clientLastUpdatedMeta =
      const VerificationMeta('clientLastUpdated');
  GeneratedDateTimeColumn _clientLastUpdated;
  @override
  GeneratedDateTimeColumn get clientLastUpdated =>
      _clientLastUpdated ??= _constructClientLastUpdated();
  GeneratedDateTimeColumn _constructClientLastUpdated() {
    return GeneratedDateTimeColumn(
      'client_last_updated',
      $tableName,
      false,
    );
  }

  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  GeneratedBoolColumn _deleted;
  @override
  GeneratedBoolColumn get deleted => _deleted ??= _constructDeleted();
  GeneratedBoolColumn _constructDeleted() {
    return GeneratedBoolColumn(
      'deleted',
      $tableName,
      false,
    );
  }

  final VerificationMeta _tutorIdMeta = const VerificationMeta('tutorId');
  GeneratedIntColumn _tutorId;
  @override
  GeneratedIntColumn get tutorId => _tutorId ??= _constructTutorId();
  GeneratedIntColumn _constructTutorId() {
    return GeneratedIntColumn(
      'tutor_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [localId, grade, name, lastUpdated, clientLastUpdated, deleted, tutorId];
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
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('client_last_updated')) {
      context.handle(
          _clientLastUpdatedMeta,
          clientLastUpdated.isAcceptableOrUnknown(
              data['client_last_updated'], _clientLastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_clientLastUpdatedMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted'], _deletedMeta));
    } else if (isInserting) {
      context.missing(_deletedMeta);
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
  final int tutorId;
  final int classId;
  TextModel(
      {@required this.localId,
      @required this.title,
      @required this.body,
      @required this.tutorId,
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
      tutorId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}tutor_id']),
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
    if (!nullToAbsent || tutorId != null) {
      map['tutor_id'] = Variable<int>(tutorId);
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
      tutorId: tutorId == null && nullToAbsent
          ? const Value.absent()
          : Value(tutorId),
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
      tutorId: serializer.fromJson<int>(json['tutor_id']),
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
      'tutor_id': serializer.toJson<int>(tutorId),
      'class_id': serializer.toJson<int>(classId),
    };
  }

  TextModel copyWith(
          {int localId, String title, String body, int tutorId, int classId}) =>
      TextModel(
        localId: localId ?? this.localId,
        title: title ?? this.title,
        body: body ?? this.body,
        tutorId: tutorId ?? this.tutorId,
        classId: classId ?? this.classId,
      );
  @override
  String toString() {
    return (StringBuffer('TextModel(')
          ..write('localId: $localId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('tutorId: $tutorId, ')
          ..write('classId: $classId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      localId.hashCode,
      $mrjc(title.hashCode,
          $mrjc(body.hashCode, $mrjc(tutorId.hashCode, classId.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TextModel &&
          other.localId == this.localId &&
          other.title == this.title &&
          other.body == this.body &&
          other.tutorId == this.tutorId &&
          other.classId == this.classId);
}

class TextModelsCompanion extends UpdateCompanion<TextModel> {
  final Value<int> localId;
  final Value<String> title;
  final Value<String> body;
  final Value<int> tutorId;
  final Value<int> classId;
  const TextModelsCompanion({
    this.localId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.tutorId = const Value.absent(),
    this.classId = const Value.absent(),
  });
  TextModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required String title,
    @required String body,
    @required int tutorId,
    @required int classId,
  })  : title = Value(title),
        body = Value(body),
        tutorId = Value(tutorId),
        classId = Value(classId);
  static Insertable<TextModel> custom({
    Expression<int> localId,
    Expression<String> title,
    Expression<String> body,
    Expression<int> tutorId,
    Expression<int> classId,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (tutorId != null) 'tutor_id': tutorId,
      if (classId != null) 'class_id': classId,
    });
  }

  TextModelsCompanion copyWith(
      {Value<int> localId,
      Value<String> title,
      Value<String> body,
      Value<int> tutorId,
      Value<int> classId}) {
    return TextModelsCompanion(
      localId: localId ?? this.localId,
      title: title ?? this.title,
      body: body ?? this.body,
      tutorId: tutorId ?? this.tutorId,
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
    if (tutorId.present) {
      map['tutor_id'] = Variable<int>(tutorId.value);
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
          ..write('tutorId: $tutorId, ')
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

  final VerificationMeta _tutorIdMeta = const VerificationMeta('tutorId');
  GeneratedIntColumn _tutorId;
  @override
  GeneratedIntColumn get tutorId => _tutorId ??= _constructTutorId();
  GeneratedIntColumn _constructTutorId() {
    return GeneratedIntColumn(
      'tutor_id',
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
  List<GeneratedColumn> get $columns =>
      [localId, title, body, tutorId, classId];
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
    if (data.containsKey('tutor_id')) {
      context.handle(_tutorIdMeta,
          tutorId.isAcceptableOrUnknown(data['tutor_id'], _tutorIdMeta));
    } else if (isInserting) {
      context.missing(_tutorIdMeta);
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

class CorrectionModel extends DataClass implements Insertable<CorrectionModel> {
  final int localId;
  final int wordIndex;
  final String commentary;
  final int textId;
  final int studentId;
  CorrectionModel(
      {@required this.localId,
      @required this.wordIndex,
      @required this.commentary,
      @required this.textId,
      @required this.studentId});
  factory CorrectionModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return CorrectionModel(
      localId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}local_id']),
      wordIndex:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}word_index']),
      commentary: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}commentary']),
      textId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}text_id']),
      studentId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}student_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<int>(localId);
    }
    if (!nullToAbsent || wordIndex != null) {
      map['word_index'] = Variable<int>(wordIndex);
    }
    if (!nullToAbsent || commentary != null) {
      map['commentary'] = Variable<String>(commentary);
    }
    if (!nullToAbsent || textId != null) {
      map['text_id'] = Variable<int>(textId);
    }
    if (!nullToAbsent || studentId != null) {
      map['student_id'] = Variable<int>(studentId);
    }
    return map;
  }

  CorrectionModelsCompanion toCompanion(bool nullToAbsent) {
    return CorrectionModelsCompanion(
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      wordIndex: wordIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(wordIndex),
      commentary: commentary == null && nullToAbsent
          ? const Value.absent()
          : Value(commentary),
      textId:
          textId == null && nullToAbsent ? const Value.absent() : Value(textId),
      studentId: studentId == null && nullToAbsent
          ? const Value.absent()
          : Value(studentId),
    );
  }

  factory CorrectionModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CorrectionModel(
      localId: serializer.fromJson<int>(json['local_id']),
      wordIndex: serializer.fromJson<int>(json['word_index']),
      commentary: serializer.fromJson<String>(json['commentary']),
      textId: serializer.fromJson<int>(json['text_id']),
      studentId: serializer.fromJson<int>(json['student_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_id': serializer.toJson<int>(localId),
      'word_index': serializer.toJson<int>(wordIndex),
      'commentary': serializer.toJson<String>(commentary),
      'text_id': serializer.toJson<int>(textId),
      'student_id': serializer.toJson<int>(studentId),
    };
  }

  CorrectionModel copyWith(
          {int localId,
          int wordIndex,
          String commentary,
          int textId,
          int studentId}) =>
      CorrectionModel(
        localId: localId ?? this.localId,
        wordIndex: wordIndex ?? this.wordIndex,
        commentary: commentary ?? this.commentary,
        textId: textId ?? this.textId,
        studentId: studentId ?? this.studentId,
      );
  @override
  String toString() {
    return (StringBuffer('CorrectionModel(')
          ..write('localId: $localId, ')
          ..write('wordIndex: $wordIndex, ')
          ..write('commentary: $commentary, ')
          ..write('textId: $textId, ')
          ..write('studentId: $studentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      localId.hashCode,
      $mrjc(
          wordIndex.hashCode,
          $mrjc(commentary.hashCode,
              $mrjc(textId.hashCode, studentId.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CorrectionModel &&
          other.localId == this.localId &&
          other.wordIndex == this.wordIndex &&
          other.commentary == this.commentary &&
          other.textId == this.textId &&
          other.studentId == this.studentId);
}

class CorrectionModelsCompanion extends UpdateCompanion<CorrectionModel> {
  final Value<int> localId;
  final Value<int> wordIndex;
  final Value<String> commentary;
  final Value<int> textId;
  final Value<int> studentId;
  const CorrectionModelsCompanion({
    this.localId = const Value.absent(),
    this.wordIndex = const Value.absent(),
    this.commentary = const Value.absent(),
    this.textId = const Value.absent(),
    this.studentId = const Value.absent(),
  });
  CorrectionModelsCompanion.insert({
    this.localId = const Value.absent(),
    @required int wordIndex,
    @required String commentary,
    @required int textId,
    @required int studentId,
  })  : wordIndex = Value(wordIndex),
        commentary = Value(commentary),
        textId = Value(textId),
        studentId = Value(studentId);
  static Insertable<CorrectionModel> custom({
    Expression<int> localId,
    Expression<int> wordIndex,
    Expression<String> commentary,
    Expression<int> textId,
    Expression<int> studentId,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (wordIndex != null) 'word_index': wordIndex,
      if (commentary != null) 'commentary': commentary,
      if (textId != null) 'text_id': textId,
      if (studentId != null) 'student_id': studentId,
    });
  }

  CorrectionModelsCompanion copyWith(
      {Value<int> localId,
      Value<int> wordIndex,
      Value<String> commentary,
      Value<int> textId,
      Value<int> studentId}) {
    return CorrectionModelsCompanion(
      localId: localId ?? this.localId,
      wordIndex: wordIndex ?? this.wordIndex,
      commentary: commentary ?? this.commentary,
      textId: textId ?? this.textId,
      studentId: studentId ?? this.studentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (wordIndex.present) {
      map['word_index'] = Variable<int>(wordIndex.value);
    }
    if (commentary.present) {
      map['commentary'] = Variable<String>(commentary.value);
    }
    if (textId.present) {
      map['text_id'] = Variable<int>(textId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorrectionModelsCompanion(')
          ..write('localId: $localId, ')
          ..write('wordIndex: $wordIndex, ')
          ..write('commentary: $commentary, ')
          ..write('textId: $textId, ')
          ..write('studentId: $studentId')
          ..write(')'))
        .toString();
  }
}

class $CorrectionModelsTable extends CorrectionModels
    with TableInfo<$CorrectionModelsTable, CorrectionModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $CorrectionModelsTable(this._db, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  GeneratedIntColumn _localId;
  @override
  GeneratedIntColumn get localId => _localId ??= _constructLocalId();
  GeneratedIntColumn _constructLocalId() {
    return GeneratedIntColumn('local_id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _wordIndexMeta = const VerificationMeta('wordIndex');
  GeneratedIntColumn _wordIndex;
  @override
  GeneratedIntColumn get wordIndex => _wordIndex ??= _constructWordIndex();
  GeneratedIntColumn _constructWordIndex() {
    return GeneratedIntColumn(
      'word_index',
      $tableName,
      false,
    );
  }

  final VerificationMeta _commentaryMeta = const VerificationMeta('commentary');
  GeneratedTextColumn _commentary;
  @override
  GeneratedTextColumn get commentary => _commentary ??= _constructCommentary();
  GeneratedTextColumn _constructCommentary() {
    return GeneratedTextColumn(
      'commentary',
      $tableName,
      false,
    );
  }

  final VerificationMeta _textIdMeta = const VerificationMeta('textId');
  GeneratedIntColumn _textId;
  @override
  GeneratedIntColumn get textId => _textId ??= _constructTextId();
  GeneratedIntColumn _constructTextId() {
    return GeneratedIntColumn('text_id', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES text_models(local_id)');
  }

  final VerificationMeta _studentIdMeta = const VerificationMeta('studentId');
  GeneratedIntColumn _studentId;
  @override
  GeneratedIntColumn get studentId => _studentId ??= _constructStudentId();
  GeneratedIntColumn _constructStudentId() {
    return GeneratedIntColumn('student_id', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES student_models(local_id)');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [localId, wordIndex, commentary, textId, studentId];
  @override
  $CorrectionModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'correction_models';
  @override
  final String actualTableName = 'correction_models';
  @override
  VerificationContext validateIntegrity(Insertable<CorrectionModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id'], _localIdMeta));
    }
    if (data.containsKey('word_index')) {
      context.handle(_wordIndexMeta,
          wordIndex.isAcceptableOrUnknown(data['word_index'], _wordIndexMeta));
    } else if (isInserting) {
      context.missing(_wordIndexMeta);
    }
    if (data.containsKey('commentary')) {
      context.handle(
          _commentaryMeta,
          commentary.isAcceptableOrUnknown(
              data['commentary'], _commentaryMeta));
    } else if (isInserting) {
      context.missing(_commentaryMeta);
    }
    if (data.containsKey('text_id')) {
      context.handle(_textIdMeta,
          textId.isAcceptableOrUnknown(data['text_id'], _textIdMeta));
    } else if (isInserting) {
      context.missing(_textIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id'], _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  CorrectionModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CorrectionModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CorrectionModelsTable createAlias(String alias) {
    return $CorrectionModelsTable(_db, alias);
  }
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
  $CorrectionModelsTable _correctionModels;
  $CorrectionModelsTable get correctionModels =>
      _correctionModels ??= $CorrectionModelsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userModels,
        classroomModels,
        studentModels,
        textModels,
        correctionModels
      ];
}
