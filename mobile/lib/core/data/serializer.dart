import 'package:moor/moor.dart';

// Don't change the order!
enum Role { teacher, support, researcher }
enum Modality { municipal, estadual, federal, privada }

class Serializer extends ValueSerializer {
  @override
  T fromJson<T>(json) {
    if (T == Role)
      return Role.values[json] as T;
    else if (T == Modality)
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
    else if (T == Modality)
      return (value as Modality).index;
    else if (value == null)
      return 'set to null';
    else
      return value;
  }
}
