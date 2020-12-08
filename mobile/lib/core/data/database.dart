import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return VmDatabase(file);
  });
}

@UseMoor(tables: [UserModels])
class Database extends _$Database {
  Database() : super(_openConnection());

  Future<UserModel> get activeUser => select(userModels).getSingle();
  Future<void> createOrUpdateUser(UserModel model) async {
    if (await activeUser == null)
      into(userModels).insert(model);
    else
      update(userModels).replace(model);
  }

  @override
  int get schemaVersion => 1;
}
