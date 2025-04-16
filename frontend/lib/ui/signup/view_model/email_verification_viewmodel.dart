import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/ui/models/verification_code/verification_code.dart';
import 'package:frontend/utils/command.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  EmailVerificationViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    verifyCode = Command1<void, VerificationCode>(_verifyCode);
  }

  final AtProtoRepository _atProtoRepository;
  late Command1<void, VerificationCode> verifyCode;

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

  Future<Result<double>> getCodeTTL() async {
    return await _atProtoRepository.getVerificationCodeExpiration();
  }
}
