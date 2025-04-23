import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:flutter/widgets.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

import 'package:frontend/ui/models/login/login.dart';

/// ViewModel for the login screen.
class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    login = Command1<Uri, Login>(_login);
  }

	/// The repository for interacting with the AT Protocol.
  final AtProtoRepository _atProtoRepository;

	/// The command to initiate the login process.
  late final Command1<Uri, Login> login;

	/// Initiates the login process with the given login payload.
  Future<Result<Uri>> _login(Login signinPayload) async {
    final result = await _atProtoRepository.getAuthorizationURI(
      signinPayload.identity,
      signinPayload.oAuthService,
    );
    switch (result) {
      case Ok<Uri>():
        return result;
      case Error<Uri>():
        logger.e('Error signing in: ${result.error}');
        return result;
    }
  }
}
