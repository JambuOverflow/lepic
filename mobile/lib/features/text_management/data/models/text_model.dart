import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:moor/moor.dart';
import 'package:mobile/core/data/database.dart';

class TextModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();

  @JsonKey("class_id")
  IntColumn get classId => integer()
      .customConstraint('NOT NULL REFERENCES classroom_models(local_id)')();
}

Text textModelToEntity(TextModel model) {
  return Text(
      localId: model.localId,
      title: model.title,
      body: model.body,
      classId: model.classId);
}

TextModel textEntityToModel(Text entity) {
  return TextModel(
      localId: entity.localId,
      title: entity.title,
      body: entity.body,
      classId: entity.classId);
}

