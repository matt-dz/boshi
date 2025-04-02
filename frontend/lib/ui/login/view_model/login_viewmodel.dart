import 'package:frontend/data/repositories/oauth/oauth_repository.dart';

import 'package:flutter/widgets.dart';

import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';
import 'package:frontend/utils/logger.dart';

import 'package:frontend/ui/models/login/login.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required OAuthRepository oAuthRepository,
  }) : _oAuthRepository = oAuthRepository {
    login = Command1<Uri, Login>(_login);
  }

  final OAuthRepository _oAuthRepository;
  late Command1<Uri, Login> login;

  Future<Result<Uri>> _login(Login signinPayload) async {
    final result = await _oAuthRepository.getAuthorizationURI(
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
