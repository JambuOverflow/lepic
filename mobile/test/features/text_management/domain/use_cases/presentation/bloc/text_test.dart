import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/create_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/delete_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_texts_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/update_text_use_case.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';
import 'package:mockito/mockito.dart';

class MockCreateTextUseCase extends Mock implements CreateText {}

class MockUpdateTextEventUseCase extends Mock implements UpdateText {}

class MockDeleteTextEventUseCase extends Mock implements DeleteText {}

class MockGetTextEventUseCase extends Mock implements GetTexts {}

void main() {
  TextBloc bloc;
  MockCreateTextUseCase mockCreateNewText;
  MockUpdateTextEventUseCase mockUpdateText;
  MockDeleteTextEventUseCase mockDeleteText;
  MockGetTextEventUseCase mockGetText;

  setUp(() {
    mockCreateNewText = MockCreateTextUseCase();
    mockUpdateText = MockUpdateTextEventUseCase();
    mockDeleteText = MockDeleteTextEventUseCase();
    mockGetText = MockGetTextEventUseCase();

    bloc = TextBloc(
      createText: mockCreateNewText,
      updateText: mockUpdateText,
      deleteText: mockDeleteText,
      getTexts: mockGetText,
    );
  });

  final tText = MyText(
    title: 'Title',
    body: 'lsfnlefnmsldkcnsdlivnir siicjsidcjsidj ifsdvjspijcekmdkcsie',
    localId: 001,
    classId: 010,
  );

  final tTextList = List<MyText>();
  tTextList.add(tText);

  final tClassroom = Classroom(
    tutorId: 010,
    grade: 001,
    name: 'textClassroomName',
  );

  final String tTitle = 'Title';
  final String tBody =
      'lsfnlefnmsldkcnsdlivnir siicjsidcjsidj ifsdvjspijcekmdkcsie';
  final int tLocalId = 001;
  final int tClassId = 010;

  test('initial state should be [TextInitial]', () {
    expect(bloc.state, TextInitial());
  });

  group('CreateNewText', () {
    test(
        '''should emit [CreatingTest, TestCreated] when text creation is successful''',
        () {
      when(mockCreateNewText(any)).thenAnswer((_) async => Right(tText));

      final expected = [
        CreatingText(),
        TextCreated(text: tText),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateNewTextEvent(
        tTitle,
        tBody,
        tLocalId,
        tClassId,
      ));
    });

    test('''should emit [CreatingTest, Error] when text could not be created''',
        () {
      when(mockCreateNewText(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        CreatingText(),
        Error(message: 'Could not create a text'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateNewTextEvent(
        tTitle,
        tBody,
        tLocalId,
        tClassId,
      ));
    });
  });

  group('updateText', () {
    test('''should emit [UpdatingText, TextUpdated] when a Text update 
    is successful''', () async {
      when(mockUpdateText(any)).thenAnswer(
        (_) async => Right(tText),
      );

      final expected = [
        UpdatingText(),
        TextUpdated(text: tText),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateTextEvent(
        tTitle,
        tBody,
        tLocalId,
        tClassId,
      ));
    });

    test('''should emit [UpdatingStudent, Error] when text update 
    is unsuccessful''', () {
      when(mockUpdateText(any)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        UpdatingText(),
        Error(message: 'Not able to update a text')
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateTextEvent(
        tTitle,
        tBody,
        tLocalId,
        tClassId,
      ));
    });
  });

  group('''Delete a given text''', () {
    test(
        '''Should emit [DeletingText, TextDeleted] when a text is deleted successfully''',
        () {
      when(mockDeleteText(any)).thenAnswer((_) async => Right(Response));

      final expected = [
        DeletingText(),
        TextDeleted(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(DeleteTextEvent(
        tLocalId,
      ));
    });

    test(
        '''Should emit [DeletingClassroom, Error] when a text could not be deleted successfully''',
        () {
      when(mockDeleteText(any)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        DeletingText(),
        Error(message: 'could not delete this text'),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(DeleteTextEvent(
        tLocalId,
      ));
    });
  });

  group('''Read a text list''', () {
    test(
        '''Should emit [GettingTextList, GotTextList] when get a student list''',
        () {
      when(mockGetText(ClassroomParams(classroom: tClassroom)))
          .thenAnswer((_) async => Right(tTextList));

      final expected = [
        GettingTextList(),
        GotTextList(texts: tTextList),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetTextEvent(
        tTitle,
        tBody,
        tLocalId,
        tClassId,
      ));
    });

    test(
        '''Should emit [GettingTextList, Error] when could not get a text list''',
        () {
      when(mockGetText(any)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        GettingTextList(),
        Error(message: 'Not able to get student list'),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetTextEvent(
        tTitle,
        tBody,
        tLocalId,
        tClassId,
      ));
    });
  });
}
