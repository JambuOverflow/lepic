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
  Database.customExecutor(QueryExecutor executor) : super(executor);

  Future<UserModel> get activeUser => select(userModels).getSingle();
  Future<UserModel> userById(int id) {
    return (select(userModels)..where((t) => t.localId.equals(id))).getSingle();
  }

  Future<bool> updateUser(UserModel model) async {
    return update(userModels).replace(model);
  }

  Future<int> insertUser(UserModel model) async {
    return into(userModels).insert(model);
  }

  @override
  int get schemaVersion => 1;
}
