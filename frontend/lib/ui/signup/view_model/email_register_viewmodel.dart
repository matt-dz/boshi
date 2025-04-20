import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';

class EmailRegisterViewModel extends ChangeNotifier {
  EmailRegisterViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    addEmail = Command1<void, String>(_addEmail);
  }

  final AtProtoRepository _atProtoRepository;
  late final Command1<void, String> addEmail;

  Future<Result<void>> _addEmail(String email) async {
    try {
      return await _atProtoRepository.addVerificationEmail(email);
    } finally {
      notifyListeners();
    }
  }
}
