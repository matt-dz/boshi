import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.freezed.dart';
part 'login.g.dart';

/// Class to represent a login request.
@freezed
abstract class Login with _$Login {
  factory Login({
    required String identity,
    required String oAuthService,
  }) = _Login;

  factory Login.fromJson(Map<String, Object?> json) => _$LoginFromJson(json);
}
