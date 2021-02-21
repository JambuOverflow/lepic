class ServerException implements Exception {
  final String message;

  ServerException({this.message});
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message});
}

class EmptyDataException implements Exception {
  final String message;

  EmptyDataException({this.message});
}
