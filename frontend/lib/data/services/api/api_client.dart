import 'dart:io';
import 'dart:convert';
import 'package:atproto/atproto.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/internal/config/environment.dart';
import 'package:frontend/internal/exceptions/missing_env.dart';
import 'package:frontend/internal/feed/feed.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/domain/models/user/user.dart';
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

/// Set the session variables in the shared preferences
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

/// A class that handles API requests to the backend and bluesky service.
class ApiClient {

	/// A method to retrieve the handle of a user from their DID.
	///
	/// @param bluesky The Bluesky instance to use for the request.
	/// @returns A [Result] containing the feed or an error.
  Future<Result<bsky.Feed>> getFeed(bsky.Bluesky bluesky) async {
    logger.d('Getting Feed');

    if (!EnvironmentConfig.prod) {
      return Result.ok(mockGetFeedResult);
    }

    if (EnvironmentConfig.feedGenUri == '') {
      return Result.error(
        MissingEnvException('FEED_GENERATOR_URI'),
      );
    }

    final generatorUri = AtUri.parse(EnvironmentConfig.feedGenUri);

    final xrpcResponse = await bluesky.feed.getFeed(generatorUri: generatorUri);

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

	/// A method to resolve the user instance from the Bluesky service.
	///
	/// @param bluesky The Bluesky instance to use for the request.
	/// @param did The DID of the user to resolve.
	/// @returns A [Result] containing the user or an error.
  Future<Result<User>> getUser(bsky.Bluesky bluesky, String did) async {
    logger.d('Sending GET request for User $did');

    if (!EnvironmentConfig.prod) {
      return Result.ok(mockUser);
    }

    final Uri hostUri = Uri.parse(EnvironmentConfig.backendBaseURL);
    final Uri requestUri = hostUri.replace(pathSegments: ['user', did]);
    final userResponse = await http.get(requestUri);

    if (userResponse.statusCode == 400) {
      return throw HttpException('Failed to get user, missing user_ids');
    } else if (userResponse.statusCode == 404) {
      return throw UserNotFoundException();
    } else if (userResponse.statusCode > 299) {
      return throw HttpException(
        'Failed to get user with status: ${userResponse.statusCode}',
      );
    }

    try {
      final Map<String, dynamic> decoded = json.decode(userResponse.body);
      decoded['handle'] = await resolveHandle(bluesky, did);
      logger.d('User decoded: $decoded');
      final User user = User.fromJson(decoded);
      return Result.ok(user);
    } on Exception catch (error) {
      logger.e('Failed to get user: $error');
      return Result.error(error);
    }
  }

	/// A method to resolve a list of users from their DIDs.
	///
	/// @param bluesky The Bluesky instance to use for the request.
	/// @param did The DID of the user to resolve.
	/// @returns A [Result] containing the users or an error.
  Future<Result<List<User>>> getUsers(List<String> dids) async {
    final Uri hostUri = Uri.parse(EnvironmentConfig.backendBaseURL);
    final Uri requestUri = hostUri.replace(
      pathSegments: ['users'],
      queryParameters: {'user_id': dids},
    );

    if (!EnvironmentConfig.prod) {
      return Result.ok([mockUser]);
    }

    logger.d('Sending request');
    final response = await http.get(requestUri);

    if (response.statusCode == 400) {
      return Result.error(
        Exception('Failed to get user, missing user_ids'),
      );
    } else if (response.statusCode == 404) {
      logger.e(response.body);
      return Result.error(UserNotFoundException());
    } else if (response.statusCode > 299) {
      logger.e(response.body);
      return Result.error(HttpException(response.body));
    }

    try {
      logger.d('Decoding response: ${response.body}');
      final decoded = json.decode(response.body) as Map<String, Object?>;
      final users = decoded['users']! as List;
      return Result.ok(users.map((user) => User.fromJson(user)).toList());
    } on Exception catch (error) {
      logger.e('Failed to decode response. error=$error');
      return Result.error(error);
    }
  }

	/// A method to create a post on the Bluesky service.
	///
	/// @param bluesky The Bluesky instance to use for the request.
	/// @param did The DID of the user to resolve.
	/// @returns A [Result] containing the result or an error.
  Future<Result<void>> createPost(
    bsky.Bluesky bluesky,
    String title,
    String content,
  ) async {
    logger.d('Creating post');
    final xrpcResponse = await bluesky.feed.post(
      text: '$title\n$content',
      tags: ['boshi.post'],
      facets: [
        bsky.Facet(
          index: bsky.ByteSlice(byteStart: 0, byteEnd: title.length),
          features: [bsky.FacetFeature.tag(data: bsky.FacetTag(tag: 'boshi'))],
        ),
      ],
    );

    if (xrpcResponse.status == HttpStatus.ok) {
      return Result.ok(null);
    } else {
      return Result.error(
        HttpException(
          'Failed to create post record with status: ${xrpcResponse.status}',
        ),
      );
    }
  }

	/// A method to create a reply on the Bluesky service.
	///
	/// @param bluesky The Bluesky instance to use for the request.
	/// @param reply The reply record to create.
	/// @returns A [Result] containing the result or an error.
  Future<Result<void>> createReply(
    bsky.Bluesky bluesky,
    bsky.PostRecord reply,
  ) async {
    logger.d('Creating reply');
    final xrpcResponse = await bluesky.feed.post(
        text: reply.text,
        tags: ['boshi.reply'],
        facets: [
          bsky.Facet(
            index: bsky.ByteSlice(byteStart: 0, byteEnd: 0),
            features: [
              bsky.FacetFeature.tag(data: bsky.FacetTag(tag: 'boshi'))
            ],
          ),
        ],
        reply: reply.reply);

    if (xrpcResponse.status != HttpStatus.ok) {
      return Result.error(
        HttpException(
          'Failed to create a reply record with status: ${xrpcResponse.status}',
        ),
      );
    }
    return Result.ok(null);
  }

	/// A method to retrieve the post thread from the Bluesky service.
	///
	/// @param bluesky The Bluesky instance to use for the request.
	/// @param url The URL of the post thread to retrieve.
	/// @returns A [Result] containing the thread or an error.
  Future<Result<bsky.PostThread>> getPostThread(
    bsky.Bluesky bluesky,
    AtUri url,
  ) async {
    logger.d('getting post thread');

    if (!EnvironmentConfig.prod) {
      return Result.ok(mockGetPostThreadResult);
    }

    final xrpcResponse = await bluesky.feed.getPostThread(uri: url);

    if (xrpcResponse.status != HttpStatus.ok) {
      return Result.error(
        HttpException(
          'Failed to get post thread with status: ${xrpcResponse.status}',
        ),
      );
    }

    return Result.ok(xrpcResponse.data);
  }

  /// A method to retrieve the OAuth client metadata.
	///
	/// @param clientId The client ID of the OAuth client.
	/// @returns The [OAuthClientMetadata] object containing the metadata.
	/// @throws OAuthException if the request fails.
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

	/// A method to retrieve the OAuth authorization URI.
	///
	/// @param client The OAuth client to use for the request.
	/// @param identity The identity of the user to authorize.
	/// @returns A tuple containing the authorization URI and the OAuth context.
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

	/// A method to generate an OAuth session.
	///
	/// @param client The OAuth client to use for the request.
	/// @param callback The callback URL to use for the request.
	/// @returns The [OAuthSession] object containing the session information.
	/// @throws ArgumentError if the OAuth variables are not set.
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

	/// A method to refresh the OAuth session.
	///
	/// @param client The OAuth client to use for the request.
	/// @returns A tuple containing the refreshed session and the ATProto instance.
	/// @throws ArgumentError if no session is stored.
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

	/// A method to retrieve the like URI from the Bluesky service.
	///
	/// @param atp The ATProto instance to use for the request.
	/// @param uri The URI of the post to retrieve the like URI for.
	/// @param did The DID of the user to retrieve the like URI for.
	/// @returns The [AtUri] object containing the like URI.
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

	/// A method to confirm the verification code sent to the user's email.
	///
	/// @param email The email address to verify.
	/// @param code The verification code sent to the email address.
	/// @param authorDID The DID of the user to verify.
	/// @returns A [Result] containing the verification status or an error.
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

	/// A method to retrieve the verification status of a user.
	///
	/// @param userDID The DID of the user to verify.
	/// @returns A [Result] containing the verification status or an error.
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

	/// A method to retrieve the time-to-live (TTL) of the verification code.
	///
	/// @param userDID The DID of the user to verify.
	/// @returns A [Result] containing the verification code TTL or an error.
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

	/// A method to add a like to a post on the Bluesky service.
	///
	/// @param bluesky The Bluesky instance to use for the request.
	/// @param cid The CID of the post to like.
	/// @param uri The URI of the post to like.
	/// @returns A [Result] containing the URI of the like or an error.
  Future<Result<AtUri>> addLike(
    bsky.Bluesky bluesky,
    String cid,
    AtUri uri,
  ) async {
    try {
      logger.d('Sending like request');
      final res = await bluesky.feed.like(cid: cid, uri: uri);
      logger.d('Received response: $res');
      if (res.status.code > 299) {
        throw HttpException(res.status.message);
      }
      return Result.ok(res.data.uri);
    } on Exception catch (e) {
      logger.e('Request failed. error=$e');
      return Result.error(e);
    }
  }

	/// A method to remove a like from a post on the Bluesky service.
	///
	/// @param atp The ATProto instance to use for the request.
	/// @param bluesky The Bluesky instance to use for the request.
	/// @param uri The URI of the post to remove the like from.
	/// @param did The DID of the user to remove the like from.
	/// @returns A [Result] containing the result of the operation or an error.
  Future<Result<void>> removeLike(
    ATProto atp,
    bsky.Bluesky bluesky,
    AtUri uri,
    String did,
  ) async {
    try {
      final likeUri = await retrieveLikeUri(atp, uri, did);
      if (likeUri == null) {
        throw Exception('Record not found');
      }

      logger.d('Deleting like record');
      final res = await bluesky.atproto.repo.deleteRecord(
        uri: likeUri,
      );

      if (res.status.code > 299) {
        throw HttpException(res.status.message);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      logger.e('Request failed. error=$e');
      return Result.error(e);
    }
  }

	/// A method to logout the user.
  Future<void> logout() async {
    final prefs = SharedPreferencesAsync();
    await prefs.clear();
  }
}
