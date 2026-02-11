import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
    String? bio,
  }) = _Profile;
}
