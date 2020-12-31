import 'package:moor/moor.dart';

import '../database.dart';
import '../../../features/class_management/domain/entities/classroom.dart';
import '../../../features/user_management/data/data_sources/user_local_data_source.dart';

class ClassroomEntityModelConverter {
  final UserLocalDataSource userLocalDataSource;

  ClassroomEntityModelConverter({@required this.userLocalDataSource});

  Classroom classroomModelToEntity(ClassroomModel model) {
    return Classroom(
      id: model.localId,
      grade: model.grade,
      name: model.name,
      deleted: model.deleted,
      lastUpdated: model.lastUpdated,
      clientLastUpdated: model.clientLastUpdated,
    );
  }

  Future<ClassroomModel> classroomEntityToModel(Classroom entity) async {
    bool deleted;
    DateTime lastUpdated;

    if (entity.deleted == null) {
      deleted = false;
    } else {
      deleted = entity.deleted;
    }

    if (entity.lastUpdated == null) {
      lastUpdated = DateTime(0).toUtc();
    } else {
      lastUpdated = entity.lastUpdated;
    }
    final int userId = await userLocalDataSource.getUserId();

    return ClassroomModel(
      localId: entity.id,
      grade: entity.grade,
      name: entity.name,
      tutorId: userId,
      lastUpdated: lastUpdated,
      deleted: deleted,
      clientLastUpdated: entity.clientLastUpdated,
    );
  }
}
