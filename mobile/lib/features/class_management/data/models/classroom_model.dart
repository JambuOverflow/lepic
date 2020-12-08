import 'package:moor/moor.dart';

class ClassroomModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  IntColumn get grade => integer()();
  TextColumn get name => text()();
  @JsonKey("tutor_id")
  IntColumn get tutorId =>
      integer().customConstraint('NOT NULL REFERENCES user_models(local_id)')();
}
/*
class ClassroomModel extends Classroom {
  ClassroomModel({
    @required User tutor,
    @required int grade,
    @required String name,
    @required int id,
  }) : super(grade: grade, tutor: tutor, name: name, id: id);

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    final tutor = (UserModel.fromJson(json['tutor']) as User);

    return ClassroomModel(
      tutor: tutor,
      grade: (json['grade'] as num).toInt(),
      name: json['name'],
      id: (json['id'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tutor': (tutor as UserModel).toJson(),
      'grade': grade,
      'id': id,
      'name': name,
    };
  }
}
*/
