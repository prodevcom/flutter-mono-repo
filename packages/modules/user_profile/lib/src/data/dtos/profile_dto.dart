import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/profile.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@freezed
abstract class ProfileDto with _$ProfileDto {
  ProfileDto._();

  const factory ProfileDto({
    required String id,
    required String name,
    required String email,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? bio,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) => _$ProfileDtoFromJson(json);

  factory ProfileDto.fromEntity(Profile profile) => ProfileDto(
        id: profile.id,
        name: profile.name,
        email: profile.email,
        phone: profile.phone,
        avatarUrl: profile.avatarUrl,
        bio: profile.bio,
      );

  Profile toEntity() => Profile(
        id: id,
        name: name,
        email: email,
        phone: phone,
        avatarUrl: avatarUrl,
        bio: bio,
      );
}
