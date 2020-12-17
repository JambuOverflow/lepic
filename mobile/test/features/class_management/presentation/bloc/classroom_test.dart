import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/create_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/delete_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classrooms_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/update_classroom_use_case.dart';
import 'package:mobile/features/class_management/presentation/bloc/class_bloc.dart';
import 'package:mockito/mockito.dart';

class MockCreateClassroomUseCase extends Mock implements CreateClassroom {}

class MockUpdateClassroomUseCase extends Mock implements UpdateClassroom {}

class MockDeleteClassroomUseCase extends Mock implements DeleteClassroom {}

class MockGetClassroomUseCase extends Mock implements GetClassrooms {}

void main() {
  ClassroomBloc bloc;
  MockCreateClassroomUseCase mockCreateClassroomUseCase;
  MockUpdateClassroomUseCase mockUpdateClassroomUseCase;
  MockDeleteClassroomUseCase mockDeleteClassroomUseCase;
  MockGetClassroomUseCase mockGetClassroomUseCase;

  setUp(() {
    mockCreateClassroomUseCase = MockCreateClassroomUseCase();
    mockUpdateClassroomUseCase = MockUpdateClassroomUseCase();
    mockDeleteClassroomUseCase = MockDeleteClassroomUseCase();
    mockGetClassroomUseCase = MockGetClassroomUseCase();

    bloc = ClassroomBloc(
      updateClassroom: mockUpdateClassroomUseCase,
      deleteClassroom: mockDeleteClassroomUseCase,
      createNewClassroom: mockCreateClassroomUseCase,
      getClassroom: mockGetClassroomUseCase,
    );
  });

  final tClassroom = Classroom(
    id: 001,
    tutorId: 001,
    grade: 01,
    name: 'thurminha',
  );

  final int tId = 001;
  final int tTutorId = 001;
  final int tGrade = 01;
  final String tName = 'thurminha';

  test('initial state should be [GetClassroom]', () {
    expect(bloc.state, GetClassroom());
  });

  group('''Create new Classroom''', () {
    test('''Should emit [CreatingClassroom, ClassroomCreated] when
          classroom is created successfuly''', () {
      when(mockCreateClassroomUseCase(any))
          .thenAnswer((_) async => Right(tClassroom));

      final expected = [
        CreatingClassroom(),
        ClassroomCreated(response: tClassroom),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateNewClassroomEvent(
        tTutorId,
        tId,
        tGrade,
        tName,
      ));
    });

    test('''Should emit [CreatingClassroom, Error] when
          classroom could not be created''', () {
      when(mockCreateClassroomUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        CreatingClassroom(),
        Error(message: 'Could not create a classroom'),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateNewClassroomEvent(
        tTutorId,
        tId,
        tGrade,
        tName,
      ));
    });
  });

  group('''Update Classroom''', () {
    test(
        '''Should emit [UpdatingClassroom, ClassroomUpdated] when classroom is updeted successfuly''',
        () {
      when(mockUpdateClassroomUseCase(any))
          .thenAnswer((_) async => Right(tClassroom));

      final expected = [
        UpdatingClassroom(),
        ClassroomUpdated(response: tClassroom),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateClassroomEvent(
        tTutorId,
        tId,
        tGrade,
        tName,
      ));
    });

    test(
        '''Should emit [UpdatingClassroom, Error] when classroom could not be updeted''',
        () {
      when(mockUpdateClassroomUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        UpdatingClassroom(),
        Error(message: 'Could not update this classroom'),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateClassroomEvent(
        tTutorId,
        tId,
        tGrade,
        tName,
      ));
    });
  });
}
