import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
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
  MockCreateStudentUseCase mockCreateNewStudent;
  MockUpdateStudentEventUseCase mockUpdateStudent;
  MockDeleteStudentEventUseCase mockDeleteStudent;
  MockGetStudentsEventUseCase mockGetStudent;

  final tStudent = Student(
    firstName: 'joãozinho',
    lastName: 'da Silva',
    id: 1,
    classroomId: 001,
  );

  final tStudentList = <Student>[tStudent];

  final tClassroom = Classroom(
    grade: 1,
    id: 001,
    name: "class name",
  );

  setUp(
    () {
      mockCreateNewStudent = MockCreateStudentUseCase();
      mockUpdateStudent = MockUpdateStudentEventUseCase();
      mockDeleteStudent = MockDeleteStudentEventUseCase();
      mockGetStudent = MockGetStudentsEventUseCase();
      bloc = StudentBloc(
        classroom: tClassroom,
        createStudent: mockCreateNewStudent,
        getStudents: mockGetStudent,
        deleteStudent: mockDeleteStudent,
        updateStudent: mockUpdateStudent,
      );

      when(mockGetStudent(ClassroomParams(classroom: tClassroom))).thenAnswer(
        (_) async => Right(tStudentList),
      );
    },
  );

  final String tFirstName = 'joãozinho';
  final String tLastName = 'da Silva';

  test(
    'initial state should be [StudentNotLoaded]',
    () {
      expect(bloc.state, StudentsLoadInProgress());
    },
  );

  group(
    'createStudent',
    () {
      test(
        '''should emit [StudentsLoaded] when student creation is successful''',
        () {
          when(mockCreateNewStudent(any))
              .thenAnswer((_) async => Right(tStudent));

          final expected = StudentsLoaded(students: tStudentList);

          expectLater(bloc, emits(expected));
          bloc.add(
            CreateStudentEvent(
              firstName: tFirstName,
              lastName: tLastName,
            ),
          );
        },
      );

      blocTest(
        'should update students list after student creation',
        build: () {
          when(mockCreateNewStudent(any))
              .thenAnswer((_) async => Right(tStudent));
          return bloc;
        },
        act: (bloc) {
          bloc.add(
              CreateStudentEvent(firstName: tFirstName, lastName: tLastName));
          bloc.add(
              CreateStudentEvent(firstName: tFirstName, lastName: tLastName));
          bloc.add(
              CreateStudentEvent(firstName: tFirstName, lastName: tLastName));
        },
        verify: (bloc) => bloc.students.length == 3,
      );

      test(
        '''should emit [Error] when student could not be created''',
        () {
          when(mockCreateNewStudent(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          final expected = Error(message: 'Could not create student');

          expectLater(bloc, emits(expected));
          bloc.add(
              CreateStudentEvent(firstName: tFirstName, lastName: tLastName));
        },
      );
    },
  );

  group(
    'updateStudent',
    () {
      test(
        'should emit [StudentsLoaded] when a Student update is successful',
        () async {
          when(mockUpdateStudent(any)).thenAnswer((_) async => Right(tStudent));

          final expected = StudentsLoaded(students: tStudentList);

          expectLater(bloc, emits(expected));
          bloc.add(
            UpdateStudentEvent(
              firstName: tFirstName,
              lastName: tLastName,
              oldStudent: tStudent,
            ),
          );
        },
      );

      test(
        '''should emit [UpdateStudentEvent, Error] when student update 
    is unsuccessful''',
        () {
          when(mockUpdateStudent(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          final expected = Error(message: 'Not able to update a text');

          expectLater(bloc, emits(expected));
          bloc.add(
            UpdateStudentEvent(
                firstName: tFirstName,
                lastName: tLastName,
                oldStudent: tStudent),
          );
        },
      );
    },
  );

  group(
    'deleteStudent',
    () {
      test(
        'Should emit [StudentsLoaded] when a student is deleted successfully',
        () {
          when(mockDeleteStudent(any)).thenAnswer((_) async => Right(Response));

          final expected = StudentsLoaded(students: tStudentList);

          expectLater(bloc, emits(expected));
          bloc.add(DeleteStudentEvent(student: tStudent));
        },
      );

      blocTest(
        'should update students list after student deletion',
        build: () {
          when(mockCreateNewStudent(any))
              .thenAnswer((_) async => Right(tStudent));
          when(mockDeleteStudent(any)).thenAnswer((_) async => Right(tStudent));
          return bloc;
        },
        act: (bloc) {
          bloc.add(
              CreateStudentEvent(firstName: tFirstName, lastName: tLastName));
          bloc.add(DeleteStudentEvent(student: tStudent));
        },
        verify: (bloc) => bloc.students.isEmpty,
      );

      test(
        'Should emit [Error] when a student could not be deleted successfully',
        () {
          when(mockDeleteStudent(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          final expected = Error(message: 'could not delete this student');

          expectLater(bloc, emits(expected));
          bloc.add(DeleteStudentEvent(student: tStudent));
        },
      );
    },
  );

  group(
    'getStudents',
    () {
      test(
        'Should emit [StudentsLoaded] when students loaded successfuly',
        () {
          when(mockGetStudent(ClassroomParams(classroom: tClassroom)))
              .thenAnswer((_) async => Right(tStudentList));

          final expected = [
            StudentsLoadInProgress(),
            StudentsLoaded(students: tStudentList),
          ];

          expectLater(bloc, emitsInOrder(expected));
          bloc.add(LoadStudentsEvent());
        },
      );

      test(
        'Should emit [Error] when can not get the students list',
        () {
          when(mockGetStudent(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          final expected = [
            StudentsLoadInProgress(),
            Error(message: 'Not able to get students list'),
          ];

          expectLater(bloc, emitsInOrder(expected));
          bloc.add(LoadStudentsEvent());
        },
      );
    },
  );
}
