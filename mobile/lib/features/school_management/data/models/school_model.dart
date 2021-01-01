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
  IntColumn get userId => integer()();
}
