import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:flutter/material.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/ui/models/verification_code/verification_code.dart';
import 'package:frontend/internal/command/command.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  EmailVerificationViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    load = Command0(_load)..execute();
    verifyCode = Command1<void, VerificationCode>(_verifyCode);
    resendCode = Command1<void, String>(_resendCode);
  }

  final AtProtoRepository _atProtoRepository;
  late Command0 load;
  late final Command1<void, VerificationCode> verifyCode;
  late final Command1<void, String> resendCode;

  void reload() {
    load = Command0(_load)..execute();
    notifyListeners();
  }

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
      final result = await _atProtoRepository.addVerificationEmail(email);
      reload();
      return result;
    } finally {
      notifyListeners();
    }
  }
}
