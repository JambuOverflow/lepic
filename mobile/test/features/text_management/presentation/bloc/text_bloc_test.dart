import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/create_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/delete_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_texts_of_classroom_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_texts_of_classroom_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/update_text_use_case.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';
import 'package:mockito/mockito.dart';

class MockCreateTextUseCase extends Mock implements CreateTextUseCase {}

class MockUpdateTextEventUseCase extends Mock implements UpdateTextUseCase {}

class MockDeleteTextEventUseCase extends Mock implements DeleteTextUseCase {}

class MockGetTextEventUseCase extends Mock implements GetTextsOfClassroomUseCase {}

void main() {
  TextBloc bloc;
  MockCreateTextUseCase mockCreateNewText;
  MockUpdateTextEventUseCase mockUpdateText;
  MockDeleteTextEventUseCase mockDeleteText;
  MockGetTextEventUseCase mockGetTextOfClassroom;

  final tText = MyText(
    title: 'Title',
    body: 'lsfnlefnmsldkcnsdlivnir siicjsidcjsidj ifsdvjspijcekmdkcsie',
    localId: 001,
    classId: 010,
  );

  final tTextList = <MyText>[tText];

  final tClassroom = Classroom(
    grade: 001,
    name: 'textClassroomName',
    id: 3,
  );

  setUp(() {
    mockCreateNewText = MockCreateTextUseCase();
    mockUpdateText = MockUpdateTextEventUseCase();
    mockDeleteText = MockDeleteTextEventUseCase();
    mockGetTextOfClassroom = MockGetTextEventUseCase();

    bloc = TextBloc(
      classroom: tClassroom,
      createText: mockCreateNewText,
      updateText: mockUpdateText,
      deleteText: mockDeleteText,
      getTextsOfClassroom: mockGetTextOfClassroom,
    );

    when(mockGetTextOfClassroom(ClassroomParams(classroom: tClassroom)))
        .thenAnswer((_) async => Right(tTextList));
  });

  final String tTitle = 'Title';
  final String tBody =
      'lsfnlefnmsldkcnsdlivnir siicjsidcjsidj ifsdvjspijcekmdkcsie';

  test('initial state should be [TextInitial]', () {
    expect(bloc.state, TextsLoadInProgress());
  });

  group('CreateNewText', () {
    test('''should emit [TextsLoaded] when text creation is successful''', () {
      when(mockCreateNewText(any)).thenAnswer((_) async => Right(tText));

      final expected = TextsLoaded(tTextList);

      expectLater(bloc, emits(expected));
      bloc.add(CreateTextEvent(title: tTitle, body: tBody));
    });

    blocTest(
      'should update texts list after text creation',
      build: () {
        when(mockCreateNewText(any)).thenAnswer((_) async => Right(tText));
        return bloc;
      },
      act: (bloc) {
        bloc.add(CreateTextEvent(title: tTitle, body: tBody));
        bloc.add(CreateTextEvent(title: tTitle, body: tBody));
        bloc.add(CreateTextEvent(title: tTitle, body: tBody));
      },
      verify: (bloc) => bloc.texts.length == 3,
    );

    test('''should emit [Error] when text could not be created''', () {
      when(mockCreateNewText(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = Error(message: 'Could not create text');

      expectLater(bloc, emits(expected));
      bloc.add(CreateTextEvent(title: tTitle, body: tBody));
    });
  });

  group('updateText', () {
    test('should emit [TextsLoaded] when a Text update is successful',
        () async {
      when(mockUpdateText(any)).thenAnswer((_) async => Right(tText));

      final expected = TextsLoaded(tTextList);

      expectLater(bloc, emits(expected));
      bloc.add(UpdateTextEvent(
        title: tTitle,
        body: tBody,
        oldText: tText,
      ));
    });

    test('''should emit [UpdatingStudent, Error] when text update 
    is unsuccessful''', () {
      when(mockUpdateText(any)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = Error(message: 'Not able to update a text');

      expectLater(bloc, emits(expected));
      bloc.add(UpdateTextEvent(title: tTitle, body: tBody, oldText: tText));
    });
  });

  group('Delete a given text', () {
    test('Should emit [TextsLoaded] when a text is deleted successfully', () {
      when(mockDeleteText(any)).thenAnswer((_) async => Right(Response));

      final expected = TextsLoaded(tTextList);

      expectLater(bloc, emits(expected));
      bloc.add(DeleteTextEvent(text: tText));
    });

    blocTest(
      'should update texts list after text deletion',
      build: () {
        when(mockCreateNewText(any)).thenAnswer((_) async => Right(tText));
        when(mockDeleteText(any)).thenAnswer((_) async => Right(tText));
        return bloc;
      },
      act: (bloc) {
        bloc.add(CreateTextEvent(title: tTitle, body: tBody));
        bloc.add(DeleteTextEvent(text: tText));
      },
      verify: (bloc) => bloc.texts.isEmpty,
    );

    test('Should emit [Error] when a text could not be deleted successfully',
        () {
      when(mockDeleteText(any)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = Error(message: 'could not delete this text');

      expectLater(bloc, emits(expected));
      bloc.add(DeleteTextEvent(text: tText));
    });
  });

  group('Get texts', () {
    test('Should emit [TextsLoaded] when texts loaded successfuly', () {
      when(mockGetTextOfClassroom(ClassroomParams(classroom: tClassroom)))
          .thenAnswer((_) async => Right(tTextList));

      final expected = [
        TextsLoadInProgress(),
        TextsLoaded(tTextList),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetTextsEvent());
    });

    test('Should emit [Error] when can not get the text list', () {
      when(mockGetTextOfClassroom(any)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        TextsLoadInProgress(),
        Error(message: 'Not able to get student list'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetTextsEvent());
    });
  });
}
