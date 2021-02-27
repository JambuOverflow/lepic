import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:moor/moor.dart';

import '../database.dart';
import '../../../features/user_management/data/data_sources/user_local_data_source.dart';

class TextEntityModelConverter {
  final UserLocalDataSource userLocalDataSource;

  TextEntityModelConverter({@required this.userLocalDataSource});

  MyText mytextModelToEntity(TextModel model) {
    return MyText(
      localId: model.localId,
      title: model.title,
      body: model.body,
      studentId: model.studentId,
      dateCreated: model.dateCreated,
    );
  }

  Future<TextModel> mytextEntityToModel(MyText entity) async {
    final int userId = await userLocalDataSource.getUserId();

    return TextModel(
        localId: entity.localId,
        body: entity.body,
        title: entity.title,
        studentId: entity.studentId,
        dateCreated: entity.dateCreated,
        tutorId: userId);
  }
}
