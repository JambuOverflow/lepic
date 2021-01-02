import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/class_management/domain/use_cases/create_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/delete_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classrooms_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/update_classroom_use_case.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/presentation/bloc/auth_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile/core/utils/input_converter.dart';

class MockInputConverter extends Mock implements InputConverter {}

class MockAuthBloc extends Mock implements AuthBloc {}

class MockCreateClassroom extends Mock implements CreateClassroom {}

class MockDeleteClassroom extends Mock implements DeleteClassroom {}

class MockUpdateClassroom extends Mock implements UpdateClassroom {}

class MockGetClassrooms extends Mock implements GetClassrooms {}

void main() {
  ClassroomBloc bloc;
  MockInputConverter mockInputConverter;
  MockAuthBloc mockAuthBloc;
  MockCreateClassroom createClassroom;
  MockDeleteClassroom deleteClassroom;
  MockUpdateClassroom updateClassroom;
  MockGetClassrooms getClassrooms;

  final tUser = User(
    localId: 1,
    firstName: 'Fulano',
    lastName: 'de Tal',
    email: 'aaa@email.com',
    role: Role.teacher,
    password: '123456',
  );

  final tClassroom = Classroom(
    grade: 1,
    name: 'className',
  );

  final List<Classroom> tClassrooms = [
    tClassroom,
    Classroom(grade: 7, name: 'no name'),
  ];

  final tGradeString = tClassroom.grade.toString();
  final tGradeParsed = tClassroom.grade;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockAuthBloc = MockAuthBloc();

    createClassroom = MockCreateClassroom();
    deleteClassroom = MockDeleteClassroom();
    updateClassroom = MockUpdateClassroom();
    getClassrooms = MockGetClassrooms();

    bloc = ClassroomBloc(
      authBloc: mockAuthBloc,
      inputConverter: mockInputConverter,
      updateClassroom: updateClassroom,
      deleteClassroom: deleteClassroom,
      createNewClassroom: createClassroom,
      getClassrooms: getClassrooms,
    );

    when(getClassrooms(any)).thenAnswer((_) async => Right(tClassrooms));
  });

  test('initial state should be GettingClassroom', () {
    expect(bloc.state, ClassroomsLoadInProgress());
  });

  test('should emit [Error] when user is not authenticated', () {
    when(mockAuthBloc.state).thenReturn(AuthState(user: null));

    final expected = Error(message: 'User not authenticated');

    expectLater(bloc, emits(expected));
    bloc.add(LoadClassroomsEvent());
  });

  void setUpMockAuthAuthenticated() {
    when(mockAuthBloc.state).thenReturn(AuthState(
      user: tUser,
      status: AuthStatus.authenticated,
    ));
  }

  void setUpMockInputConverterSuccess() =>
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tGradeParsed));

  void setUpMockInputConverterFailure() =>
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

  group('createNewClassroom', () {
    test(
      '''should call the InputConverter to validate and convert 
      the string to an unsigned integer''',
      () async {
        setUpMockInputConverterSuccess();
        setUpMockAuthAuthenticated();

        when(createClassroom(any)).thenAnswer((_) async => Right(tClassroom));

        bloc.add(CreateClassroomEvent(
          grade: tGradeString,
          name: tClassroom.name,
        ));

        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

        verify(mockInputConverter.stringToUnsignedInteger(tGradeString));
      },
    );

    test(
      '''should get created classroom from use case''',
      () async {
        setUpMockInputConverterSuccess();
        setUpMockAuthAuthenticated();

        when(createClassroom(any)).thenAnswer((_) async => Right(tClassroom));

        bloc.add(CreateClassroomEvent(
          grade: tGradeString,
          name: tClassroom.name,
        ));

        await untilCalled(createClassroom(any));

        verify(createClassroom(ClassroomParams(classroom: tClassroom)));
      },
    );

    test('''should emit [CreatingClassroom, ClassroomsLoaded] when
        classroom creation is successful''', () async {
      setUpMockInputConverterSuccess();
      setUpMockAuthAuthenticated();

      when(createClassroom(any)).thenAnswer((_) async => Right(tClassroom));

      final expected = [
        CreatingClassroom(),
        ClassroomsLoaded(),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateClassroomEvent(
        grade: tClassroom.grade.toString(),
        name: tClassroom.name,
      ));
    });

    test('''should emit [CreatingClassroom, Error] when
        classroom creation is successful''', () async {
      setUpMockInputConverterSuccess();
      setUpMockAuthAuthenticated();

      when(createClassroom(any)).thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        CreatingClassroom(),
        Error(message: 'Unexpected Error'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateClassroomEvent(
        grade: tClassroom.grade.toString(),
        name: tClassroom.name,
      ));
    });

    test('''must have a input converter error''', () async {
      setUpMockInputConverterFailure();
      setUpMockAuthAuthenticated();

      final expected = [
        CreatingClassroom(),
        Error(message: 'input invalid'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateClassroomEvent(
        grade: tClassroom.grade.toString(),
        name: tClassroom.name,
      ));
    });
  });

  group('deleteClassroom', () {
    test('''should emit [DeletingClassroom, ClassroomsLoaded] when
        classroom creation is successful''', () async {
      setUpMockAuthAuthenticated();

      when(deleteClassroom(any)).thenAnswer((_) async => Right(null));

      final expected = [
        DeletingClassroom(),
        ClassroomsLoaded(),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(DeleteClassroomEvent(classroom: tClassroom));
    });

    test('''should emit [DeletingClassroom, Error] when
        classroom creation is unsuccessful''', () async {
      setUpMockAuthAuthenticated();

      when(deleteClassroom(any)).thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        DeletingClassroom(),
        Error(message: 'oh no'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(DeleteClassroomEvent(classroom: tClassroom));
    });

    test(
      '''should get created classroom from use case''',
      () async {
        setUpMockAuthAuthenticated();

        when(deleteClassroom(any)).thenAnswer((_) async => Right(null));

        bloc.add(DeleteClassroomEvent(classroom: tClassroom));

        await untilCalled(deleteClassroom(any));

        verify(deleteClassroom(ClassroomParams(classroom: tClassroom)));
      },
    );
  });

  group('updateClassroom', () {
    test(
      '''should call the InputConverter to validate and convert 
      the string to an unsigned integer''',
      () async {
        setUpMockInputConverterSuccess();
        setUpMockAuthAuthenticated();

        when(updateClassroom(any)).thenAnswer((_) async => Right(tClassroom));

        bloc.add(UpdateClassroomEvent(
          classroom: tClassroom,
          grade: tGradeString,
          name: tClassroom.name,
        ));

        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

        verify(mockInputConverter.stringToUnsignedInteger(tGradeString));
      },
    );

    test('''should emit [UpdatingClassrooom, ClassroomsLoaded] when
         classroom update is successful''', () async {
      setUpMockAuthAuthenticated();
      setUpMockInputConverterSuccess();

      when(updateClassroom(any)).thenAnswer((_) async => Right(tClassroom));

      final expected = [
        UpdatingClassroom(),
        ClassroomsLoaded(),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateClassroomEvent(
        grade: tGradeString,
        classroom: tClassroom,
      ));
    });

    test('''should emit [Updating, Error] when
        classroom update is unsuccessful''', () async {
      setUpMockAuthAuthenticated();
      setUpMockInputConverterSuccess();

      when(updateClassroom(any)).thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        UpdatingClassroom(),
        Error(message: 'deu ruim cantinho e agora?'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateClassroomEvent(
        grade: tGradeString,
        classroom: tClassroom,
      ));
    });

    test('''should emit [Updating, Error] when
        input convertion failed''', () async {
      setUpMockAuthAuthenticated();
      setUpMockInputConverterFailure();

      when(updateClassroom(any)).thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        UpdatingClassroom(),
        Error(message: 'deu ruim cantinho e agora?'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateClassroomEvent(
        grade: tGradeString,
        classroom: tClassroom,
      ));
    });
  });

  group('''getClassrooms''', () {
    test('''Should emit [Gettingclassrooms, ClassroomsLoaded] when
         get a classroom list''', () {
      setUpMockAuthAuthenticated();

      when(getClassrooms(any)).thenAnswer((_) async => Right(tClassrooms));

      final expected = [
        ClassroomsLoadInProgress(),
        ClassroomsLoaded(),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoadClassroomsEvent());
    });

    test('''Should emit [Gettingclassrooms, Error] when could not 
        get a classroom list''', () {
      setUpMockAuthAuthenticated();

      when(getClassrooms(any)).thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        ClassroomsLoadInProgress(),
        Error(message: 'Not able to get classroom list'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoadClassroomsEvent());
    });
  });
}
