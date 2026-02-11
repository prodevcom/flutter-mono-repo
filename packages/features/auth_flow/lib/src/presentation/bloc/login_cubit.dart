import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:auth_module/auth_module.dart';

part 'login_cubit.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState.initial() = LoginInitial;
  const factory LoginState.loading() = LoginLoading;
  const factory LoginState.success(User user) = LoginSuccess;
  const factory LoginState.failure(String message) = LoginFailure;
}

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUseCase) : super(const LoginState.initial());

  final LoginUseCase _loginUseCase;

  Future<void> login({required String email, required String password}) async {
    emit(const LoginState.loading());

    final result = await _loginUseCase(LoginParams(email: email, password: password));

    result.when(
      success: (user) => emit(LoginState.success(user)),
      failure: (failure) => emit(LoginState.failure(failure.message)),
    );
  }
}
