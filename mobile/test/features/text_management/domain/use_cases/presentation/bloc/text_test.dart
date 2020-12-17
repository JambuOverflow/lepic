import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
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

  final tText = Text(
    title: 'Title',
    body: 'lsfnlefnmsldkcnsdlivnir siicjsidcjsidj ifsdvjspijcekmdkcsie',
    localId: 001,
    classId: 010,
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
}
