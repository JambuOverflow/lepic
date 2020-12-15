import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/create_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/delete_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/update_student_use_case.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mockito/mockito.dart';

class MockCreateStudentUseCase extends Mock implements CreateStudent {}

class MockUpdateStudentEventUseCase extends Mock implements UpdateStudent {}

class MockDeleteStudentEventUseCase extends Mock implements DeleteStudent {}

class MockGetStudentsEventUseCase extends Mock implements GetStudents {}

void main() {
  StudentBloc bloc;
  MockCreateStudentUseCase mockCreateNewStudentEvent;
  MockUpdateStudentEventUseCase mockUpdateStudentEvent;
  MockDeleteStudentEventUseCase deleteStudentEvent;
  MockGetStudentsEventUseCase mockGetStudentEvent;

  setUp(() {
    mockCreateNewStudentEvent = MockCreateStudentUseCase();
    mockUpdateStudentEvent = MockUpdateStudentEventUseCase();
    deleteStudentEvent = MockDeleteStudentEventUseCase();
    mockGetStudentEvent = MockGetStudentsEventUseCase();
    bloc = StudentBloc(
        createStudent: mockCreateNewStudentEvent,
        getStudents: mockGetStudentEvent,
        deleteStudent: deleteStudentEvent,
        updateStudent: mockUpdateStudentEvent);
  });

  final tStudent = Student(
    firstName: 'joãozinho',
    lastName: 'da Silva',
    id: 1,
    classroomId: 001,
  );

  test('initial state should be [StudentNotLoaded]', () {
    expect(bloc.state, StudentNotLoaded());
  });
}
