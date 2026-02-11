abstract class Failure {
  const Failure({required this.message, this.stackTrace});

  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.stackTrace, this.statusCode});

  final int? statusCode;
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.stackTrace});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection', super.stackTrace});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred', super.stackTrace});
}
