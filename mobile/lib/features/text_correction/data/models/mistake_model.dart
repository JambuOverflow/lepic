import 'package:moor/moor.dart';

class MistakeModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  @JsonKey("word_index")
  IntColumn get wordIndex => integer()();
  TextColumn get commentary => text()();
  @JsonKey('correction_id')
  IntColumn get correctionId => integer()
      .customConstraint('NOT NULL REFERENCES correction_models(local_id) ON DELETE CASCADE')();
  
}
