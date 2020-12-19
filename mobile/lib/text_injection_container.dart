import 'package:get_it/get_it.dart';
import 'package:mobile/features/text_management/data/data_sources/text_local_data_source.dart';
import 'package:mobile/features/text_management/data/repositories/text_repository_impl.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/create_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/delete_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_texts_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/update_text_use_case.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

final slText = GetIt.instance;

void init() {
  slText.registerFactory(
    () => TextBloc(
      updateText: slText(),
      deleteText: slText(),
      createText: slText(),
      getTexts: slText(),
    ),
  );

  slText.registerLazySingleton(() => CreateText(repository: slText()));
  slText.registerLazySingleton(() => UpdateText(repository: slText()));
  slText.registerLazySingleton(() => DeleteText(repository: slText()));
  slText.registerLazySingleton(() => GetTexts(repository: slText()));

  slText.registerLazySingleton<TextRepository>(
    () => TextRepositoryImpl(
      localDataSource: slText(),
    ),
  );

  slText.registerLazySingleton<TextLocalDataSource>(
    () => TextLocalDataSourceImpl(
      database: slText(),
    ),
  );
}
