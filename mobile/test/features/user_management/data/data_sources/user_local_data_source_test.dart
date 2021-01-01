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
          .thenAnswer((_) async => null);
      final call = dataSource.getLoggedInUser;

      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheUser', () {
    test('should override the User in the secure storage', () async {
      final userJsonString = tUserModel.toJsonString();
      when(mockSecureStorage.write(key: loggedInUserKey, value: userJsonString))
          .thenAnswer((_) async => tUserModel.localId);

      await dataSource.cacheUser(tUserModel);

      verify(mockSecureStorage.write(
        key: loggedInUserKey,
        value: userJsonString,
      ));
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

      final expected = await dataSource.retrieveToken();

      expect(expected, token);
      verify(mockSecureStorage.read(key: anyNamed('key')));
    });

    test('should throw cache exception when key is not present', () async {
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) => null);

      final call = dataSource.retrieveToken;

      expect(() => call(), throwsA(isA<CacheException>()));
      verify(mockSecureStorage.read(key: anyNamed('key')));
    });
  });

  group('logout', () {
    test('should delete stored token and stored user from secure storage',
        () async {
      when(mockSecureStorage.deleteAll()).thenAnswer((_) async => null);

      await dataSource.logout();

      verify(mockSecureStorage.deleteAll());
    });
  });

  group('getUserId', () {
    test('should get userId',
        () async {
      final userModelString = tUserModel.toJsonString();
      when(mockSecureStorage.read(key: loggedInUserKey))
          .thenAnswer((_) async => userModelString);

      final result = await dataSource.getUserId();

      expect(result, 1);
    });
  });
}
