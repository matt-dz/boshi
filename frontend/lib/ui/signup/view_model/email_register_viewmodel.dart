import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:flutter/material.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';

/// ViewModel for the Email Registration screen
class EmailRegisterViewModel extends ChangeNotifier {
  EmailRegisterViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    addEmail = Command1<void, String>(_addEmail);
  }

	/// The atproto repository for interacting with the AT Protocol.
  final AtProtoRepository _atProtoRepository;


	/// The command to add an email for verification.
  late final Command1<void, String> addEmail;

	/// The email address to be verified.
  Future<Result<void>> _addEmail(String email) async {
    try {
      return await _atProtoRepository.addVerificationEmail(email);
    } finally {
      notifyListeners();
    }
  }
}
