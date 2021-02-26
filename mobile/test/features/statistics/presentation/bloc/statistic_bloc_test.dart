import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mockito/mockito.dart';

class MockGetNumberOfWordsReadPerMinuteUseCase extends Mock
    implements GetNumberOfWordsReadPerMinuteUseCase {}

class MockGetNumberOfCorrectWordsReadPerMinuteUseCase extends Mock
    implements GetNumberOfCorrectWordsReadPerMinuteUseCase {}

void main() {
  StatisticBloc bloc;
  MockGetNumberOfWordsReadPerMinuteUseCase
      mockGetNumberOfWordsReadPerMinuteUseCase;
  MockGetNumberOfCorrectWordsReadPerMinuteUseCase
      mockGetNumberOfCorrectWordsReadPerMinuteUseCase;

  final tAudioData = File('assets/audios/test_sample.mp3').readAsBytesSync();

  final tTitle = 'Title';

  final tAudio =
      AudioEntity(data: tAudioData, studentId: 1, textId: 1, title: tTitle);

  final tStudent = Student(firstName: 'a', lastName: 'b', classroomId: 1);

  setUp(() {
    mockGetNumberOfWordsReadPerMinuteUseCase =
        MockGetNumberOfWordsReadPerMinuteUseCase();
    mockGetNumberOfCorrectWordsReadPerMinuteUseCase =
        MockGetNumberOfCorrectWordsReadPerMinuteUseCase();

    bloc = StatisticBloc(
      audio: tAudio,
      student: tStudent,
      getNumberOfWordsReadPerMinute: mockGetNumberOfWordsReadPerMinuteUseCase,
      getNumberOfCorrectWordsReadPerMinute:
          mockGetNumberOfCorrectWordsReadPerMinuteUseCase,
    );
  });

  test('initial state should be [StatisticLoading]', () {
    expect(bloc.state, StatisticLoading());
  });

  group('GetNumberOfWordsReadPerMinute', () {
    test(
        '''should emit [StatisticsLoaded] when statistics loaded successfuly''',
        () {
      when(mockGetNumberOfWordsReadPerMinuteUseCase(any))
          .thenAnswer((_) async => Right(0));

      final expected = StatisticsLoaded();

      expectLater(bloc, emits(expected));
      bloc.add(GetStatisticsEvent());
    });
  });
}
