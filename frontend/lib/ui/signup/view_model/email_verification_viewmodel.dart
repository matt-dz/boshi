import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:flutter/widgets.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  EmailVerificationViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository;

  final AtProtoRepository _atProtoRepository;
}
