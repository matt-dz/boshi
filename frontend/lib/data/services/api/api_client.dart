import 'dart:io';
import 'dart:convert';
import 'package:atproto/atproto.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/internal/config/environment.dart';
import 'package:frontend/internal/exceptions/missing_env.dart';
import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/shared/models/report/report.dart' as boshi_report;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/data/models/requests/reply/reply.dart'
    as reply_request;
import 'package:frontend/shared/models/post/post.dart' as post_request;
import 'package:http/http.dart' as http;
import 'package:frontend/data/models/requests/add_email/add_email.dart';
import 'package:frontend/data/models/requests/verify_code/verify_code.dart';
import 'package:frontend/internal/exceptions/verification_code_already_set_exception.dart';
import 'package:frontend/internal/exceptions/code_not_found_exception.dart';
import 'package:frontend/internal/exceptions/already_verified_exception.dart';
import 'package:frontend/internal/exceptions/user_not_found_exception.dart';
import 'package:frontend/data/models/responses/verification_status/verification_status.dart';
import 'package:frontend/data/models/responses/verification_code_ttl/verification_code_ttl.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/internal/feed/mock_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _setSessionVars(
  OAuthSession session,
  SharedPreferencesAsync? prefs,
) async {
  prefs ??= SharedPreferencesAsync();
  await prefs.setString(
    'session-vars',
    json.encode({
      'accessToken': session.accessToken,
      'refreshToken': session.refreshToken,
      'tokenType': session.tokenType,
      'scope': session.scope,
      'expiresAt': session.expiresAt.toString(),
      'sub': session.sub,
      r'$dPoPNonce': session.$dPoPNonce,
      r'$publicKey': session.$publicKey,
      r'$privateKey': session.$privateKey,
    }),
  );
}

class ApiClient {
  Future<Result<bsky.Feed>> getFeed(OAuthSession session) async {
    logger.d('Getting Feed');
    if (!EnvironmentConfig.prod) {
      return Result.ok(mockGetFeedResult);
    }
    final bskyServer = bsky.Bluesky.fromOAuthSession(session);

    if (EnvironmentConfig.feedGenUri == '') {
      return Result.error(
        MissingEnvException('FEED_GENERATOR_URI'),
      );
    }

    final generatorUri = AtUri.parse(EnvironmentConfig.feedGenUri);

    final xrpcResponse =
        await bskyServer.feed.getFeed(generatorUri: generatorUri);

    logger.d(xrpcResponse.data);

    if (xrpcResponse.status != HttpStatus.ok) {
      return Result.error(
        Exception(
          'Failed to get feed with status: ${xrpcResponse.status}',
        ),
      );
    }

    return Result.ok(xrpcResponse.data);
  }

  // TODO: Implement the getUser method
  Future<Result<User>> getUser() async {
    logger.w('Function not implemented. Returning default user.');
    return Result.ok(
      User(id: '1', username: 'anonymous1', school: 'University of Florida'),
    );
  }

  Future<Result<Post>> getPost(String id) async {
    logger.d('Retrieving post');
    return Result.ok(mockFeed[0]);
  }

  Future<Result<Post>> updateReactionCount(
    ReactionPayload reactionPayload,
  ) async {
    logger.d('Updating reaction count');
    return Result.ok(mockFeed[0]);
  }

  Future<Result<Post>> addReply(reply_request.Reply reply) async {
    logger.d('Adding reply');
    return Result.ok(mockFeed[0]);
  }

  Future<Result<void>> reportPost(boshi_report.Report report) async {
    logger.d('Reporting post');
    return Result.ok(null);
  }

  Future<Result<void>> createPost(
    ATProto session,
    post_request.Post post,
  ) async {
    logger.d('Creating post');
    final xrpcResponse = await session.repo.createRecord(
      collection: NSID.create('feed.boshi.app', 'post'),
      record: {
        'title': post.title,
        'content': post.content,
        'timestamp': DateTime.now().toString(),
      },
    );

    if (xrpcResponse.status == HttpStatus.ok) {
      return Result.ok(null);
    } else {
      return Result.error(
        Exception(
          'Failed to create post record with status: ${xrpcResponse.status}',
        ),
      );
    }
  }

  /// Sends a GET request to the Boshi backend to get
  /// the OAuth client metadata
  Future<OAuthClientMetadata> getOAuthClientMetadata(
    String clientId,
  ) async {
    logger.d('Sending request');
    final response = await http.get(Uri.parse(clientId));

    if (response.statusCode > 299) {
      logger.e('Failed to get client metadata: $response');
      throw OAuthException(
        'Failed to get client metadata: ${response.statusCode}',
      );
    }

    logger.d('Decoding response');
    return OAuthClientMetadata.fromJson(jsonDecode(response.body));
  }

  Future<(Uri, OAuthContext)> getOAuthAuthorizationURI(
    OAuthClient client,
    String identity,
  ) async {
    logger.d('Retrieving shared preferences instance');
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();

    logger.d('Initiating OAuth authorization request');
    final (uri, context) = await client.authorize(identity);

    logger.d('Setting OAuth variables');
    await prefs.setString('oauth-code-verifier', context.codeVerifier);
    await prefs.setString('oauth-state', context.state);
    await prefs.setString('oauth-dpop-nonce', context.dpopNonce);

    return (uri, context);
  }

  Future<OAuthSession> generateSession(
    OAuthClient client,
    String callback,
  ) async {
    logger.d('Retrieving shared preferences instance');
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();

    logger.d('Retrieving OAuth variables from storage');
    final codeVerifier = await prefs.getString('oauth-code-verifier');
    final state = await prefs.getString('oauth-state');
    final dpopNonce = await prefs.getString('oauth-dpop-nonce');

    if (codeVerifier == null || state == null || dpopNonce == null) {
      logger.e('OAuth variables not set');
      throw ArgumentError('Context not set');
    }

    final context = OAuthContext(
      codeVerifier: codeVerifier,
      state: state,
      dpopNonce: dpopNonce,
    );

    logger.d('Handling OAuth callback');
    final session = await client.callback(Uri.base.toString(), context);

    logger.d('Setting session variables');

    /// TODO: Implement JSON as a separate class
    await prefs.setString(
      'session-vars',
      json.encode({
        'accessToken': session.accessToken,
        'refreshToken': session.refreshToken,
        'tokenType': session.tokenType,
        'scope': session.scope,
        'expiresAt': session.expiresAt.toString(),
        'sub': session.sub,
        r'$dPoPNonce': session.$dPoPNonce,
        r'$publicKey': session.$publicKey,
        r'$privateKey': session.$privateKey,
      }),
    );

    return session;
  }

  Future<(OAuthSession, ATProto)> refreshSession(OAuthClient client) async {
    logger.d('Retrieving shared preferences instance');
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();

    logger.d('Retrieving OAuth session variables from shared preferences');
    final sessionVars = await prefs.getString('session-vars');
    if (sessionVars == null) {
      throw ArgumentError('No session stored');
    }

    logger.d('Decoding OAuth session variables');
    final Map<String, dynamic> sessionMap = json.decode(sessionVars);
    final session = OAuthSession(
      accessToken: sessionMap['accessToken'],
      refreshToken: sessionMap['refreshToken'],
      tokenType: sessionMap['tokenType'],
      scope: sessionMap['scope'],
      expiresAt: DateTime.parse(sessionMap['expiresAt']),
      sub: sessionMap['sub'],
      $dPoPNonce: sessionMap[r'$dPoPNonce'],
      $publicKey: sessionMap[r'$publicKey'],
      $privateKey: sessionMap[r'$privateKey'],
    );

    logger.d('Refreshing OAuth session');
    final refreshedSession = await client.refresh(session);

    logger.d('Setting session variables');
    await _setSessionVars(refreshedSession, prefs);

    return (refreshedSession, ATProto.fromOAuthSession(refreshedSession));
  }

  Future<Result<void>> addVerificationEmail(
    String email,
    String authorDID,
  ) async {
    try {
      logger.d('Sending request to add verification email');
      final result = await http.post(
        Uri.parse('${EnvironmentConfig.backendBaseURL}/email/code'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(AddEmail(userId: authorDID, email: email).toJson()),
      );

      if (result.statusCode == 429 &&
          result.body.trim() == 'Verification code already set') {
        throw VerificationCodeAlreadySetException();
      } else if (result.statusCode >= 400) {
        throw HttpException(result.body);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      logger.e('Failed to add verification email. error=$e');
      return Result.error(e);
    } catch (e) {
      logger.e('Failed to add verification email. error=$e');
      return Result.error(Exception(e));
    }
  }

  Future<Result<void>> confirmVerificationCode(
    String email,
    String code,
    String authorDID,
  ) async {
    try {
      logger.d('Sending request');
      final result = await http.post(
        Uri.parse('${EnvironmentConfig.backendBaseURL}/email/verify'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          VerifyCode(
            userId: authorDID,
            email: email,
            code: code,
          ),
        ),
      );

      if (result.statusCode == 409 &&
          result.body.trim() == 'User already verified') {
        throw AlreadyVerifiedException();
      }
      if (result.statusCode >= 400) {
        throw HttpException(result.body);
      }
      logger.d('Successfully confirmed code');
      return Result.ok(null);
    } on Exception catch (e) {
      logger.e('Failed to confirm verification code. error=$e');
      return Result.error(e);
    } catch (e) {
      logger.e('Failed to confirm verification code. error=$e');
      return Result.error(Exception(e));
    }
  }

  Future<Result<VerificationStatus>> isUserVerified(
    String userDID,
  ) async {
    try {
      logger.d('Sending request');
      final result = await http.get(
        Uri.parse(
          '${EnvironmentConfig.backendBaseURL}/user/$userDID/verification-status',
        ),
      );

      final body = result.body.trim();

      if (result.statusCode == 404 && body == 'User not found') {
        throw UserNotFoundException();
      }

      if (result.statusCode >= 400) {
        throw HttpException(result.body);
      }

      logger.d('Successfully retrieved status');
      return Result.ok(VerificationStatus.fromJson(jsonDecode(result.body)));
    } on Exception catch (e) {
      logger.e('Failed to verify user. error=$e');
      return Result.error(e);
    } catch (e) {
      logger.e('Failed to verify user. error=$e');
      return Result.error(Exception(e));
    }
  }

  Future<Result<VerificationCodeTTL>> getVerificationCodeTTL(
    String userDID,
  ) async {
    try {
      logger.d('Sending request');
      final result = await http.get(
        Uri.parse('${EnvironmentConfig.backendBaseURL}/user/$userDID/code/ttl'),
      );

      final body = result.body.trim();

      if (result.statusCode == 404) {
        if (body == 'User not found') {
          throw UserNotFoundException();
        } else if (body == 'Code not found') {
          throw CodeNotFoundException();
        }
      }
      if (result.statusCode >= 400) {
        throw HttpException(body);
      }

      logger.d('Successfully retrieved ttl');
      return Result.ok(VerificationCodeTTL.fromJson(jsonDecode(result.body)));
    } on Exception catch (e) {
      logger.e('Request failed. error=$e');
      return Result.error(e);
    } catch (e) {
      logger.e('Request failed. error=$e');
      return Result.error(Exception(e));
    }
  }
}
