import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:flutter/widgets.dart';

import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';
import 'package:frontend/utils/logger.dart';

import 'package:frontend/ui/models/login/login.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    login = Command1<Uri, Login>(_login);
  }

  final AtProtoRepository _atProtoRepository;
  late Command1<Uri, Login> login;

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
