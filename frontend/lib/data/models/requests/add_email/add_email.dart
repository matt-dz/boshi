import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_email.freezed.dart';
part 'add_email.g.dart';

@freezed
abstract class AddEmail with _$AddEmail {
  const factory AddEmail({
    required String userId,
    required String email,
  }) = _AddEmail;

  factory AddEmail.fromJson(Map<String, Object?> json) =>
      _$AddEmailFromJson(json);
}
