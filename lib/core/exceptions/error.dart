abstract interface class Error {}

final class Failure implements Error {
  final String message;

  Failure({required this.message});
}

final class InvalidZipFailure implements Error {
  final String message;

  InvalidZipFailure({required this.message});
}

final class EmptyZipFailure implements Error {
  final String message;

  EmptyZipFailure({required this.message});
}

final class Empty implements Error {}
