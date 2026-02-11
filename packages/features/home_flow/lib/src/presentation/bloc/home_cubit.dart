import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:home_module/home_module.dart';
import 'package:injectable/injectable.dart';

part 'home_cubit.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded(List<HomeItem> items) = HomeLoaded;
  const factory HomeState.failure(String message) = HomeFailure;
}

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getHomeItemsUseCase) : super(const HomeState.initial());

  final GetHomeItemsUseCase _getHomeItemsUseCase;

  Future<void> loadItems() async {
    emit(const HomeState.loading());

    final result = await _getHomeItemsUseCase();

    result.when(
      success: (items) => emit(HomeState.loaded(items)),
      failure: (failure) => emit(HomeState.failure(failure.message)),
    );
  }
}
