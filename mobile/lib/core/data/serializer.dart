import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/moor.dart';

class Serializer extends ValueSerializer {
  @override
  T fromJson<T>(json) {
    if (T == Role)
      return Role.values[json] as T;
    else if (T == DateTime) {
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(json, isUtc: true);
      return dateTime as T;
    } else if (T == Modality)
      return Modality.values[json] as T;
    else if (json == 'set to null')
      return null;
    else
      return json as T;
  }

  @override
  toJson<T>(T value) {
    if (T == Role)
      return (value as Role).index;
    else if (T == DateTime)
      return (value as DateTime).millisecondsSinceEpoch;
    else if (T == Modality)
      return (value as Modality).index;
    else if (value == null)
      return 'set to null';
    else
      return value;
  }
}
