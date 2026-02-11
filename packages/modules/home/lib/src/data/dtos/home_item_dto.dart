import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/home_item.dart';

part 'home_item_dto.freezed.dart';
part 'home_item_dto.g.dart';

@freezed
abstract class HomeItemDto with _$HomeItemDto {
  const HomeItemDto._();

  const factory HomeItemDto({
    required String id,
    required String title,
    required String description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
  }) = _HomeItemDto;

  factory HomeItemDto.fromJson(Map<String, dynamic> json) => _$HomeItemDtoFromJson(json);

  HomeItem toEntity() => HomeItem(
        id: id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        isFeatured: isFeatured,
      );
}
