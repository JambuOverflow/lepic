import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:moor/moor.dart';

import '../database.dart';
import '../../../features/user_management/data/data_sources/user_local_data_source.dart';

class SchoolEntityModelConverter {
  final UserLocalDataSource userLocalDataSource;

  SchoolEntityModelConverter({@required this.userLocalDataSource});

  School schoolModelToEntity(SchoolModel model) {
    return School(
      id: model.localId,
      name: model.name,
      neighborhood: model.neighborhood,
      city: model.city,
      state: model.state,
      modality: model.modality,
      zipCode: model.zipCode,
      userId: model.userId
    );
  }

  Future<SchoolModel> schoolEntityToModel(School entity) async {

    final int userId = await userLocalDataSource.getUserId();

    return SchoolModel(
      localId: entity.id,
      name: entity.name,
      neighborhood: entity.neighborhood,
      city: entity.city,
      state: entity.state,
      modality: entity.modality,
      zipCode: entity.zipCode,
      userId: userId
    );
  }
}
