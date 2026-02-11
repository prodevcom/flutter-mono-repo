import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_item.freezed.dart';

@freezed
abstract class HomeItem with _$HomeItem {
  const factory HomeItem({
    required String id,
    required String title,
    required String description,
    String? imageUrl,
    @Default(false) bool isFeatured,
  }) = _HomeItem;
}
