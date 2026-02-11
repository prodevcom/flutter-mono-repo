import 'result.dart';

abstract class UseCase<Input, Output> {
  Future<Result<Output>> call(Input params);
}

abstract class UseCaseNoParams<Output> {
  Future<Result<Output>> call();
}

class NoParams {
  const NoParams();
}
