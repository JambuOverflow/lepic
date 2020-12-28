import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/moor.dart';

final time = DateTime.fromMicrosecondsSinceEpoch(1514768460000, isUtc: true); 

class Serializer extends ValueSerializer {
  @override
  T fromJson<T>(json) {
    if (T == Role)
      return Role.values[json] as T;
    else if (T == DateTime)
      return DateTime.fromMillisecondsSinceEpoch(json, isUtc: true) as T;
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
    else if (value == null)
      return 'set to null';
    else
      return value;
  }
}
