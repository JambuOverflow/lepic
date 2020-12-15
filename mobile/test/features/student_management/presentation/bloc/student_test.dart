import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';

import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/create_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/delete_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mobile/features/student_management/domain/use_cases/update_student_use_case.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mockito/mockito.dart';

class MockCreateStudentUseCase extends Mock implements CreateStudent {}

class MockUpdateStudentEventUseCase extends Mock implements UpdateStudent {}

class MockDeleteStudentEventUseCase extends Mock implements DeleteStudent {}

class MockGetStudentsEventUseCase extends Mock implements GetStudents {}

void main() {
  StudentBloc bloc;
  MockCreateStudentUseCase mockCreateNewStudent;
  MockUpdateStudentEventUseCase mockUpdateStudent;
  MockDeleteStudentEventUseCase deleteStudent;
  MockGetStudentsEventUseCase mockGetStudent;

  setUp(() {
    mockCreateNewStudent = MockCreateStudentUseCase();
    mockUpdateStudent = MockUpdateStudentEventUseCase();
    deleteStudent = MockDeleteStudentEventUseCase();
    mockGetStudent = MockGetStudentsEventUseCase();
    bloc = StudentBloc(
        createStudent: mockCreateNewStudent,
        getStudents: mockGetStudent,
        deleteStudent: deleteStudent,
        updateStudent: mockUpdateStudent);
  });

  final tStudent = Student(
    firstName: 'joãozinho',
    lastName: 'da Silva',
    id: 1,
    classroomId: 001,
  );

  final String tFirstName = 'joãozinho';
  final String tLastName = 'da Silva';
  final int tId = 1;
  final int tClassroomId = 001;

  test('initial state should be [StudentNotLoaded]', () {
    expect(bloc.state, StudentNotLoaded());
  });

  group('CreateNewStudent', () {
    test(
        '''should emit [CreatingStudent, StudentCreated] when student creation is successful''',
        () {
      when(mockCreateNewStudent(any)).thenAnswer((_) async => Right(tStudent));

      final expected = [
        CreatingStudent(),
        StudentCreated(student: tStudent),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateNewStudentEvent(
        tFirstName,
        tLastName,
        tId,
        tClassroomId,
      ));
    });

    test(
        'should emit [CreatingStudent, Error] when student create is unsuccessful',
        () async {
      when(mockCreateNewStudent(StudentParams(student: tStudent)))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        CreatingStudent(),
        Error(message: 'Could not create Student')
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateNewStudentEvent(
        tFirstName,
        tLastName,
        tId,
        tClassroomId,
      ));
    });
  });

  group('updateStudent', () {
    test('''should emit [UpdatingStudent, StudentUpdated] when update 
    is successful''', () async {
      when(mockUpdateStudent(any)).thenAnswer(
        (_) async => Right(tStudent),
      );

      final expected = [UpdatingStudent(), StudentUpdated(student: tStudent)];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateStudentEvent(
        tFirstName,
        tLastName,
        tId,
        tClassroomId,
      ));
    });

    test('''should emit [UpdatingStudent, Error] when student creation 
    is unsuccessful''', () {
      when(mockUpdateStudent(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        UpdatingStudent(),
        Error(message: 'Not able to update a student')
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateStudentEvent(
        tFirstName,
        tLastName,
        tId,
        tClassroomId,
      ));
    });
  });
}
