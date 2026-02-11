import 'package:core/core.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login({required String email, required String password});
  Future<Result<void>> logout();
  Future<Result<User>> getCurrentUser();
  Future<Result<bool>> get isAuthenticated;
}
