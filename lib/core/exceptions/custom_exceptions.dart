class InvalidZipException implements Exception {
  final String message;

  InvalidZipException(this.message);

  @override
  String toString() => message;
}

class EmptyZipException implements Exception {
  final String message;

  EmptyZipException(this.message);

  @override
  String toString() => message;
}