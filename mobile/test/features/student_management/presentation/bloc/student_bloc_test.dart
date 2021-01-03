import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';

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
  MockDeleteStudentEventUseCase mockdeleteStudent;
  MockGetStudentsEventUseCase mockGetStudent;

  final tClassroom = Classroom(
    grade: 1,
    id: 001,
    name: "class name",
  );

  setUp(
    () {
      mockCreateNewStudent = MockCreateStudentUseCase();
      mockUpdateStudent = MockUpdateStudentEventUseCase();
      mockdeleteStudent = MockDeleteStudentEventUseCase();
      mockGetStudent = MockGetStudentsEventUseCase();
      bloc = StudentBloc(
          classroom: tClassroom,
          createStudent: mockCreateNewStudent,
          getStudents: mockGetStudent,
          deleteStudent: mockdeleteStudent,
          updateStudent: mockUpdateStudent);
    },
  );

  final tStudent = Student(
    firstName: 'joãozinho',
    lastName: 'da Silva',
    id: 1,
    classroomId: 001,
  );

  final tList = List<Student>();
  tList.add(tStudent);

  final String tFirstName = 'joãozinho';
  final String tLastName = 'da Silva';

  test('initial state should be [StudentNotLoaded]', () {
    expect(bloc.state, GettingStudents());
  });

  group('createNewStudent', () {
    test(
        '''should emit [CreatingStudent, StudentCreated] when student creation is successful''',
        () {
      when(mockCreateNewStudent(any)).thenAnswer((_) async => Right(tStudent));

      final expected = [
        CreatingStudent(),
        StudentCreated(student: tStudent),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateStudentEvent(
        firstName: tFirstName,
        lastName: tLastName,
      ));
    });

    test(
        'should emit [CreatingStudent, Error] when student create is unsuccessful',
        () async {
      when(mockCreateNewStudent(StudentParams(student: tStudent)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        CreatingStudent(),
        Error(message: 'Could not create Student')
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateStudentEvent(
        firstName: tFirstName,
        lastName: tLastName,
      ));
    });
  });

  group('updateStudent', () {
    test('''should emit [UpdatingStudent, StudentUpdated] when update
    is successful''', () async {
      when(mockUpdateStudent(any)).thenAnswer(
        (_) async => Right(tStudent),
      );

      final expected = [
        UpdatingStudent(),
        StudentUpdated(updatedStudent: tStudent)
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateStudentEvent(
        firstName: tFirstName,
        lastName: tLastName,
        student: tStudent,
      ));
    });

    test('''should emit [UpdatingStudent, Error] when student creation
    is unsuccessful''', () {
      when(mockUpdateStudent(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        UpdatingStudent(),
        Error(message: 'Not able to update a student')
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateStudentEvent(
        firstName: tFirstName,
        lastName: tLastName,
        student: tStudent,
      ));
    });
  });

  group('''deleteStudent''', () {
    test('''Should emit [DeletingStudent, StudentDeleted] when delete is
        successful''', () {
      when(mockdeleteStudent(any)).thenAnswer((_) async => Right(tStudent));

      final expected = [
        DeletingStudent(),
        StudentDeleted(),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(DeleteStudentEvent(student: tStudent));
    });

    test('''Should emit [DeletingStudent, Error] when delete is
        unsuccessful''', () {
      when(mockdeleteStudent(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        DeletingStudent(),
        Error(message: 'Not able to delete student'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(DeleteStudentEvent(student: tStudent));
    });
  });

  group('''getStudents''', () {
    test(
        '''Should emit [GettingStudents, StudentGot] when get a student list''',
        () {
      when(mockGetStudent(ClassroomParams(classroom: tClassroom)))
          .thenAnswer((_) async => Right(tList));

      final expected = [
        GettingStudents(),
        StudentsGot(students: tList),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetStudentsEvent());
    });

    test(
        '''Should emit [GettingStudents, Error] when could not get a student list''',
        () {
      when(mockGetStudent(any)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        GettingStudents(),
        Error(message: 'Not able to get student list'),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetStudentsEvent());
    });
  });
}
