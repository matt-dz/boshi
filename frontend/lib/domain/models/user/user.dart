import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Class to represent a user in the system.
@freezed
abstract class User with _$User {
  const factory User({
    required String did,
    required String school,
    String? handle,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
