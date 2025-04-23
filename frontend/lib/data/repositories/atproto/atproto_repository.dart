import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/foundation.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/internal/exceptions/oauth_unauthorized_exception.dart';
import 'package:frontend/internal/exceptions/verification_code_already_set_exception.dart';
import 'package:frontend/internal/exceptions/user_not_found_exception.dart';
import 'package:frontend/domain/models/post/post.dart' as domain_models;
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/feed/feed.dart';
import 'package:frontend/data/models/responses/verification_status/verification_status.dart';
import 'package:frontend/data/models/responses/verification_code_ttl/verification_code_ttl.dart';
import 'package:frontend/data/services/api/api_client.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/atproto.dart' as atp;

/// Repository for managing interactions with the AT Protocol and Bluesky API.
class AtProtoRepository extends ChangeNotifier {
  AtProtoRepository({
    required Uri clientId,
    required ApiClient apiClient,
    required bool local,
  })  : _apiClient = apiClient,
        _clientId = clientId,
        _local = local,
        clientMetadata = null,
        oAuthClient = null,
        service = 'bsky.social',
        initialized = false;

	/// The PDS service to use for the OAuth flow.
  String service;
  bool initialized;

	/// The OAuth client ID for the application.
  final Uri _clientId;

	/// The API client used to make requests to the AT Protocol and Bluesky API.
  final ApiClient _apiClient;
  final bool _local;


  late OAuthContext oAuthContext;

	/// The AT Protocol session object.
  atp.ATProto? atProto;

	/// The Bluesky session object.
  bsky.Bluesky? bluesky;

	/// The OAuth client metadata object.
  late OAuthClientMetadata? clientMetadata;

	/// The OAuth client object.
  late OAuthClient? oAuthClient;

  Uri get clientId => _clientId;

	/// Determines if the user is authorized
  bool get authorized => atProto != null && bluesky != null;

	/// Initialize the OAuth client with the provided client ID and service.
  Future<void> _initializeOAuthClient() async {
    if (_local) {
      clientMetadata ??= OAuthClientMetadata(
        clientId: '${clientId.scheme}://${clientId.host}',
        clientName: 'Boshi',
        clientUri: clientId.toString(),
        redirectUris: ['http://127.0.0.1:${clientId.port}'],
        grantTypes: ['authorization_code', 'refresh_token'],
        scope: 'atproto',
        responseTypes: ['code'],
        applicationType: 'web',
        tokenEndpointAuthMethod: 'none',
      );
      oAuthClient ??= OAuthClient(clientMetadata!, service: service);
      initialized = true;
      return;
    }
    clientMetadata ??=
        await _apiClient.getOAuthClientMetadata(clientId.toString());
    oAuthClient ??= OAuthClient(clientMetadata!, service: service);
    initialized = true;
  }

	/// Get the authorization URI for the OAuth flow.
	///
	/// @param identity The identity of the user to authorize.
	/// @param service The PDS service to use for the OAuth flow.
	/// @returns A Result object containing the result of the operation.
  Future<Result<Uri>> getAuthorizationURI(
    String identity,
    String service,
  ) async {
    try {
      this.service = service;
      await _initializeOAuthClient();
      final (uri, context) = await _apiClient.getOAuthAuthorizationURI(
        oAuthClient!,
        identity,
      );
      oAuthContext = context;
      return Result.ok(uri);
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

	
	/// Generate a session using the OAuth flow.
	///
	/// @param callback The callback URL to redirect to after authorization.
	/// @returns A Result object containing the result of the operation.
  Future<Result<void>> generateSession(String callback) async {
    try {
      await _initializeOAuthClient();
      final session = await _apiClient.generateSession(oAuthClient!, callback);
      atProto = atp.ATProto.fromOAuthSession(session);
      bluesky = bsky.Bluesky.fromOAuthSession(session);
      return Result.ok(null);
    } on Exception catch (e) {
      logger.e('Error generating session: $e');
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

	/// Refresh the OAuth session.
	///
	/// @returns A Result object containing the result of the operation.
  Future<Result<void>> refreshSession() async {
    try {
      await _initializeOAuthClient();
      final (_, newAtproto) = await _apiClient.refreshSession(oAuthClient!);
      atProto = newAtproto;
      bluesky = bsky.Bluesky.fromOAuthSession(newAtproto.oAuthSession!);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

	/// Create a new reply using the Bluesky API.
	///
	/// @param reply The reply to create.
	/// @returns A Result object containing the result of the operation.
  Future<Result<void>> createReply(bsky.PostRecord reply) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }
    return await _apiClient.createReply(bluesky!, reply);
  }

	/// Create a new post using the Bluesky API.
	///
	/// @param title The title of the post.
	/// @param content The content of the post.
	/// @returns A Result object containing the result of the operation.
  Future<Result<void>> createPost(String title, String content) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }
    return await _apiClient.createPost(bluesky!, title, content);
  }

	/// Get the thread of a post using the Bluesky API.
	///
	/// @param postUrl The URL of the post to get the thread for.
	/// @returns A Result object containing the result of the operation.
  Future<Result<bsky.PostThread>> getPostThread(AtUri postUrl) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }
    return await _apiClient.getPostThread(bluesky!, postUrl);
  }

	/// Add a verification email to the user's account.
	///
	/// @param email The email address to add.
	/// @returns A Result object containing the result of the operation.
  Future<Result<void>> addVerificationEmail(String email) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorizedException());
    }

    final result = await _apiClient.addVerificationEmail(email, userDid);
    if (result is Error<void> &&
        result.error is VerificationCodeAlreadySetException) {
      logger.d('Verification code already set. Ignoring error.');
      return Result.ok(null);
    }
    return result;
  }

	/// Confirm the verification code sent to the user's email.
	///
	/// @param email The email address to confirm.
	/// @param code The verification code to confirm.
  Future<Result<void>> confirmVerificationCode(
    String email,
    String code,
  ) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorizedException());
    }

    return await _apiClient.confirmVerificationCode(
      email,
      code,
      userDid,
    );
  }

	/// Check if the user is verified.
	///
	/// @returns A Result object containing the result of the operation.
  Future<Result<bool>> isUserVerified() async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorizedException());
    }

    final result = await _apiClient.isUserVerified(userDid);
    switch (result) {
      case Ok<VerificationStatus>():
        return Result.ok(result.value.verified);
      case Error<VerificationStatus>():
        if (result.error is UserNotFoundException) {
          return Result.ok(false); // User not found, they aren't verified
        }
        return Result.error(result.error);
    }
  }

	/// Get the time-to-live (TTL) of the verification code.
	///
	/// @returns A Result object containing the result of the operation.
  Future<Result<double>> getVerificationCodeTTL() async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorizedException());
    }

    final ttlResult = await _apiClient.getVerificationCodeTTL(userDid);
    switch (ttlResult) {
      case Ok<VerificationCodeTTL>():
        return Result.ok(ttlResult.value.ttl);
      case Error<VerificationCodeTTL>():
        return Result.error(ttlResult.error);
    }
  }

	/// Get the feed of posts from the Bluesky API.
	///
	/// @returns A Result object containing the result of the operation.
  Future<Result<List<domain_models.Post>>> getFeed() async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving feed');
    final bskyFeed = await _apiClient.getFeed(bluesky!);
    if (bskyFeed is Error) {
      return Result.error((bskyFeed as Error).error);
    }

    logger.d('Retrieving users');
    final feed = (bskyFeed as Ok).value as bsky.Feed;
    final userDids =
        feed.feed.map((post) => post.post.author.did).toSet().toList();
    final response = await _apiClient.getUsers(userDids);
    if (response is Error) {
      return Result.error((response as Error).error);
    }

    return Result.ok(
      convertFeedToDomainPosts(
        feed,
        (response as Ok<List<User>>).value,
      ),
    );
  }

	/// Get the users from the Bluesky API.
	///
	/// @param dids The list of DIDs to get users for.
	/// @returns A Result object containing the result of the operation.
  Future<Result<List<User>>> getUsers(List<String> dids) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException('getUsers'));
    }

    final usersResult = await _apiClient.getUsers(dids);
    return usersResult;
  }

  Future<Result<User>> getUser() async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    final String? userDid = atProto!.oAuthSession?.sub;

    if (userDid == null) {
      return Result.error(OAuthUnauthorizedException());
    }
    final userResult = await _apiClient.getUser(bluesky!, userDid);

    switch (userResult) {
      case Ok<User>():
        return userResult;
      case Error<User>():
        return userResult;
    }
  }

	/// Get the profile of a user from the Bluesky API.
	///
	/// @param did The DID of the user to get the profile for.
	/// @returns A Result object containing the result of the operation.
  Future<Result<AtUri>> addLike(
    AtUri uri,
    String cid,
  ) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    try {
      logger.d('Adding like');
      return await _apiClient.addLike(
        bluesky!,
        cid,
        uri,
      );
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

	/// Remove a like from a post using the Bluesky API.
	///
	/// @param uri The URI of the post to remove the like from.
	/// @param cid The CID of the post to remove the like from.
	/// @param did The DID of the user to remove the like from.
	/// @returns A Result object containing the result of the operation.
  Future<Result<void>> removeLike(
    AtUri uri,
    String cid,
    String did,
  ) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    try {
      logger.d('Removing like');
      return await _apiClient.removeLike(
        atProto!,
        bluesky!,
        uri,
        did,
      );
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

	/// Logout the user from the AT Protocol and Bluesky API.
	///
	/// @returns A Result object containing the result of the operation.
  Future<Result<void>> logout() async {
    try {
      await _apiClient.logout();
      atProto = null;
      bluesky = null;
      clientMetadata = null;
      initialized = false;
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }
}
