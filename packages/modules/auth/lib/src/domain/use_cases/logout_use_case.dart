import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@lazySingleton
class LogoutUseCase implements UseCaseNoParams<void> {
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call() => _repository.logout();
}
