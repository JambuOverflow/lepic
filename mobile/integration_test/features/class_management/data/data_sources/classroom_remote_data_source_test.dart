import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

void main() {
  http.Client client;
  UserRemoteDataSourceImpl userRemoteDataSourceImpl;
  SyncClassroom syncClassroom;
  final userModel = UserModel(
    localId: 1,
    firstName: "renan",
    lastName: "cunha",
    username: 'renardian',
    role: Role.teacher,
    password: '0907renan',
    email: 'renancunhafonseca@gmail.com',
  );

  setUp(() {
    client = http.Client();
    userRemoteDataSourceImpl = UserRemoteDataSourceImpl(client: client);
  });

  group('createAccount', () {
    test('should return a correct response from the server', () async {
      final response = await userRemoteDataSourceImpl.createUser(userModel);

      expect(response, SuccessfulResponse());
    });
  });
}
