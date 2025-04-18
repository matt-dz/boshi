import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/ui/models/verification_code/verification_code.dart';
import 'package:frontend/utils/command.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  EmailVerificationViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    load = Command0(_load)..execute();
    verifyCode = Command1<void, VerificationCode>(_verifyCode);
    resendCode = Command1<void, String>(_resendCode);
  }

  final AtProtoRepository _atProtoRepository;
  late final Command0 load;
  late final Command1<void, VerificationCode> verifyCode;
  late final Command1<void, String> resendCode;

  Future<Result<void>> _load() async {
    try {
      return await _atProtoRepository.getVerificationCodeTTL();
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _verifyCode(VerificationCode code) async {
    try {
      return await _atProtoRepository.confirmVerificationCode(
        code.email,
        code.code,
      );
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _resendCode(String email) async {
    try {
      return await _atProtoRepository.addVerificationEmail(email);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<double>> getCodeTTL() async {
    return await _atProtoRepository.getVerificationCodeTTL();
  }
}
