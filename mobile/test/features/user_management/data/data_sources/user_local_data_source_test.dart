import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';

class MockDatabase extends Mock implements Database {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  UserLocalDataSourceImpl dataSource;
  MockDatabase mockDatabase;
  MockSecureStorage mockSecureStorage;

  UserModel tUserModel = UserModel(
    localId: 1,
    firstName: 'ab',
    lastName: 'c',
    email: 'ab@g.com',
    role: Role.teacher,
    password: '123',
  );

  setUp(() {
    mockDatabase = MockDatabase();
    mockSecureStorage = MockSecureStorage();
    dataSource = UserLocalDataSourceImpl(
      database: mockDatabase,
      secureStorage: mockSecureStorage,
    );
  });

  group('getLoggedInUser', () {
    moorRuntimeOptions.defaultSerializer = UserSerializer();

    test('should return User from shared prefs when there is one stored',
        () async {
      final userModelString = tUserModel.toJsonString();
      when(mockSecureStorage.read(key: loggedInUserKey))
          .thenAnswer((_) async => userModelString);

      final result = await dataSource.getLoggedInUser();

      expect(result, tUserModel);
    });

    test('should throw a CacheException when User is not stored', () async {
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenThrow(CacheException());

      final call = dataSource.getLoggedInUser;

      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheUser', () {
    test(
        'should cache the User in the database by calling insert user '
        'when no user exists', () async {
      when(mockDatabase.insertUser(tUserModel))
          .thenAnswer((_) async => tUserModel.localId);

      final result = await dataSource.cacheUser(tUserModel);

      verify(mockDatabase.insertUser(tUserModel));
      expect(result, tUserModel.localId);
    });

    test(
        'should cache the User in the database by calling update user '
        'when the user already exists', () async {
      when(mockDatabase.activeUser).thenAnswer((_) async => tUserModel);
      when(mockDatabase.updateUser(tUserModel)).thenAnswer((_) async => true);

      final result = await dataSource.cacheUser(tUserModel);

      verify(mockDatabase.updateUser(tUserModel));
      expect(result, tUserModel.localId);
    });
  });

  group('storeTokenSecurely', () {
    final token = 'secret shh';

    test('should store token in the secure storage', () async {
      when(mockSecureStorage.write(key: anyNamed('key'), value: token))
          .thenReturn(null);

      await dataSource.storeTokenSecurely(token: token, user: tUserModel);

      final key = tUserModel.localId.toString();
      verify(mockSecureStorage.write(key: key, value: token));
    });
  });

  group('retrieveToken', () {
    final token = 'secret shh';
    test('should store token in the secure storage', () async {
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => token);

      final expected = await dataSource.retrieveToken(tUserModel);

      expect(expected, token);
      verify(mockSecureStorage.read(key: anyNamed('key')));
    });

    test('should throw cache exception when key is not present', () async {
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenThrow(CacheException());

      final call = dataSource.retrieveToken;

      expect(() => call(tUserModel), throwsA(isA<CacheException>()));
      verify(mockSecureStorage.read(key: anyNamed('key')));
    });
  });
}
