import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/create_audio_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/delete_audio_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_audio_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/update_audio_use_case.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';

class MockCreateAudioUseCase extends Mock implements CreateAudioUseCase {}

class MockUpdateAudioEventUseCase extends Mock implements UpdateAudioUseCase {}

class MockDeleteAudioEventUseCase extends Mock implements DeleteAudioUseCase {}

class MockGetAudioEventUseCase extends Mock implements GetAudioUseCase {}

void main() {
  AudioBloc bloc;
  MockCreateAudioUseCase mockCreateNewAudio;
  MockUpdateAudioEventUseCase mockUpdateAudio;
  MockDeleteAudioEventUseCase mockDeleteAudio;
  MockGetAudioEventUseCase mockGetAudio;

  final Uint8List tAudioData =
      File('assets/audios/test_sample.mp3').readAsBytesSync();
  final String tTitle = 'bom dia grupo';

  final tAudio = AudioEntity(
    data: tAudioData,
    title: tTitle,
    localId: 1,
    studentId: 001,
    textId: 010,
  );

  // final tAudioList = <AudioEntity>[tAudio];

  final tStudent = Student(
    firstName: 'joãozinho',
    lastName: 'da Silva',
    id: 001,
    classroomId: 100,
  );

  final tText = MyText(
    title: 'Cantinho',
    body: 'ablublubelbue',
    localId: 010,
    studentId: 100,
  );

  setUp(
    () {
      mockCreateNewAudio = MockCreateAudioUseCase();
      mockUpdateAudio = MockUpdateAudioEventUseCase();
      mockDeleteAudio = MockDeleteAudioEventUseCase();
      mockGetAudio = MockGetAudioEventUseCase();
      bloc = AudioBloc(
        createAudio: mockCreateNewAudio,
        getAudio: mockGetAudio,
        updateAudio: mockUpdateAudio,
        deleteAudio: mockDeleteAudio,
        student: tStudent,
        text: tText,
      );

      when(mockGetAudio(StudentTextParams(student: tStudent, text: tText)))
          .thenAnswer(
        (_) async => Right(tAudio),
      );
    },
  );

  test(
    'initial state should be [AudioNotLoaded]',
    () {
      expect(bloc.state, AudioLoadInProgress());
    },
  );

  group(
    'createAudio',
    () {
      test(
        '''should emit [AudioLoaded] when audio creation is successful''',
        () {
          when(mockCreateNewAudio(any)).thenAnswer((_) async => Right(tAudio));

          final expected = AudioLoaded(audio: tAudio);

          expectLater(bloc, emits(expected));
          bloc.add(
            CreateAudioEvent(
              audioData: tAudioData,
              title: tTitle,
            ),
          );
        },
      );

      blocTest(
        'should update audio after audio creation',
        build: () {
          when(mockCreateNewAudio(any)).thenAnswer((_) async => Right(tAudio));
          return bloc;
        },
        act: (bloc) {
          bloc.add(CreateAudioEvent(audioData: tAudioData, title: tTitle));
        },
        verify: (bloc) => bloc.audio == tAudio,
      );

      test(
        '''should emit [Error] when audio could not be created''',
        () {
          when(mockCreateNewAudio(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          final expected = Error(message: 'Could not create audio');

          expectLater(bloc, emits(expected));
          bloc.add(CreateAudioEvent(audioData: tAudioData, title: tTitle));
        },
      );
    },
  );

  group(
    'updateAudio',
    () {
      test(
        'should emit [AudioLoaded] when a Audio update is successful',
        () async {
          when(mockUpdateAudio(any)).thenAnswer((_) async => Right(tAudio));

          final expected = AudioLoaded(audio: tAudio);

          expectLater(bloc, emits(expected));
          bloc.add(
            UpdateAudioEvent(
              audioData: tAudioData,
              title: tTitle,
              oldAudio: tAudio,
            ),
          );
        },
      );

      test(
        '''should emit [UpdateAudioEvent, Error] when audio update 
    is unsuccessful''',
        () {
          when(mockUpdateAudio(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          final expected = Error(message: 'Not able to update the audio');

          expectLater(bloc, emits(expected));
          bloc.add(
            UpdateAudioEvent(
                title: tTitle, audioData: tAudioData, oldAudio: tAudio),
          );
        },
      );
    },
  );

  group(
    'deleteAudio',
    () {
      test(
        'Should emit [AudioLoaded] when a audio is deleted successfully',
        () {
          when(mockDeleteAudio(any)).thenAnswer((_) async => Right(Response));

          final expected = AudioLoaded(audio: tAudio);

          expectLater(bloc, emits(expected));
          bloc.add(DeleteAudioEvent());
        },
      );

      blocTest(
        'should update audio after audio deletion',
        build: () {
          when(mockCreateNewAudio(any)).thenAnswer((_) async => Right(tAudio));
          when(mockDeleteAudio(any)).thenAnswer((_) async => Right(tAudio));
          return bloc;
        },
        act: (bloc) {
          bloc.add(CreateAudioEvent(title: tTitle, audioData: tAudioData));
          bloc.add(DeleteAudioEvent());
        },
        verify: (bloc) => bloc.audio == null,
      );

      test(
        'Should emit [Error] when a audio could not be deleted successfully',
        () {
          when(mockDeleteAudio(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          final expected = Error(message: 'could not delete this audio');

          expectLater(bloc, emits(expected));
          bloc.add(DeleteAudioEvent());
        },
      );
    },
  );

  group(
    'getAudio',
    () {
      test(
        'Should emit [AudioLoaded] when audio is loaded successfuly',
        () {
          when(mockGetAudio(StudentTextParams(student: tStudent, text: tText)))
              .thenAnswer((_) async => Right(tAudio));

          final expected = [
            AudioLoadInProgress(),
            AudioLoaded(audio: tAudio),
          ];

          expectLater(bloc, emitsInOrder(expected));
          bloc.add(LoadAudioEvent());
        },
      );

      test(
        'Should emit [Error] when can not get the audio',
        () {
          when(mockGetAudio(any)).thenAnswer((_) async => Left(null));

          final expected = [
            AudioLoadInProgress(),
            Error(message: 'Not able to get audio'),
          ];

          expectLater(bloc, emitsInOrder(expected));
          bloc.add(LoadAudioEvent());
        },
      );
    },
  );
}
