import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:moor/moor.dart';

class SchoolModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  @JsonKey("zip_code")
  IntColumn get zipCode => integer()();
  IntColumn get modality => intEnum<Modality>()();
  TextColumn get state => text()();
  TextColumn get city => text()();
  TextColumn get neighborhood => text()();
  TextColumn get name => text()();
  @JsonKey("user_id")
  IntColumn get userId =>
      integer().customConstraint('NOT NULL REFERENCES user_models(local_id)')();
}

School schoolModelToEntity(SchoolModel model) {
  return School(
      id: model.localId,
      zipCode: model.zipCode,
      modality: model.modality,
      state: model.state,
      city: model.city,
      neighborhood: model.neighborhood,
      name: model.name,
      userId: model.userId);
}

SchoolModel schoolEntityToModel(School entity) {
  return SchoolModel(
      localId: entity.id,
      zipCode: entity.zipCode,
      modality: entity.modality,
      state: entity.state,
      city: entity.city,
      neighborhood: entity.neighborhood,
      name: entity.name,
      userId: entity.userId);
}
