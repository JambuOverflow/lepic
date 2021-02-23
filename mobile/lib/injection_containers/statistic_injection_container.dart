import 'package:get_it/get_it.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';

void init() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton(() => GetTextUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => GetCorrectionFromIdUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetNumberOfCorrectWordsReadPerMinuteUseCase(
      getCorrectionFromIdUseCase: getIt(), getTextUseCase: getIt()));
}
