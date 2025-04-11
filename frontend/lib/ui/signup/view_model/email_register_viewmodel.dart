import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:flutter/widgets.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';
import 'package:frontend/utils/logger.dart';

class EmailRegisterViewModel extends ChangeNotifier {
  EmailRegisterViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    addEmail = Command1<void, String>(_addEmail);
  }

  final AtProtoRepository _atProtoRepository;
  late Command1<void, String> addEmail;

  Future<Result<void>> _addEmail(String email) async {
    return Result.ok(null);
  }
}
