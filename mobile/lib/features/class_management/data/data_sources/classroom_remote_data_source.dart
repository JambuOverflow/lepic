import '../../../user_management/domain/entities/user.dart';
import '../../domain/entities/classroom.dart';
import 'package:http/http.dart' as http;

abstract class ClassroomRemoteDataSource {
  Future<Classroom> sendNewClassroom(Classroom classroom);
  Future<http.Response> deleteClassroom(Classroom classroom);
  Future<List<Classroom>> getClassrooms(User user);
}
