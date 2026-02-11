import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:user_profile_module/user_profile_module.dart';

part 'profile_cubit.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = ProfileInitial;
  const factory ProfileState.loading() = ProfileLoading;
  const factory ProfileState.loaded(Profile profile) = ProfileLoaded;
  const factory ProfileState.failure(String message) = ProfileFailure;
}

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfileUseCase, this._updateProfileUseCase)
      : super(const ProfileState.initial());

  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  Future<void> loadProfile() async {
    emit(const ProfileState.loading());

    final result = await _getProfileUseCase();

    result.when(
      success: (profile) => emit(ProfileState.loaded(profile)),
      failure: (failure) => emit(ProfileState.failure(failure.message)),
    );
  }

  Future<void> updateProfile(Profile profile) async {
    emit(const ProfileState.loading());

    final result = await _updateProfileUseCase(profile);

    result.when(
      success: (profile) => emit(ProfileState.loaded(profile)),
      failure: (failure) => emit(ProfileState.failure(failure.message)),
    );
  }
}
