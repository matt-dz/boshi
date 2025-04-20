import 'package:flutter/foundation.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/domain/models/post/post.dart' as domain_models;
import 'package:frontend/utils/result.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/atproto.dart' as atp;

abstract class AtProtoRepository extends ChangeNotifier {
  AtProtoRepository({
    required Uri clientId,
  })  : _clientId = clientId,
        clientMetadata = null,
        oAuthClient = null,
        service = 'bsky.social',
        initialized = false;

  String service;
  bool initialized;
  final Uri _clientId;
  late OAuthContext oAuthContext;
  atp.ATProto? atProto;

  late OAuthClientMetadata? clientMetadata;
  late OAuthClient? oAuthClient;

  Uri get clientId => _clientId;
  bool get authorized => atProto != null;

  Future<Result<Uri>> getAuthorizationURI(String identity, String service);
  Future<Result<void>> generateSession(String callback);
  Future<Result<void>> refreshSession();
  Future<Result<void>> createPost(Post post);
  Future<Result<void>> addVerificationEmail(String email);
  Future<Result<void>> confirmVerificationCode(String email, String code);
  Future<Result<bool>> isUserVerified();
  Future<Result<double>> getVerificationCodeTTL();
  Future<Result<List<domain_models.Post>>> getFeed();
  Future<Result<User>> getUser(String did);
}
