import 'dart:io';
import 'package:atproto/atproto.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/core.dart';
import 'dart:convert';
import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';
import 'package:frontend/utils/result.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/shared/models/mock_data/feed/feed.dart';
import 'package:frontend/shared/models/report/report.dart' as boshi_report;
import 'package:frontend/utils/logger.dart';
import 'package:frontend/data/models/requests/reply/reply.dart'
    as reply_request;
import 'package:frontend/shared/models/post/post.dart' as post_request;
import 'package:frontend/shared/oauth/oauth.dart' as oauth_shared;
import 'package:frontend/config/environment.dart';
import 'package:frontend/data/models/requests/add_email/add_email.dart';
import 'package:frontend/data/models/requests/verify_code/verify_code.dart';
import 'package:frontend/data/models/responses/verification_status/verification_status.dart';
import 'package:frontend/shared/exceptions/verification_code_already_set_exception.dart';
import 'package:frontend/shared/exceptions/code_not_found_exception.dart';
import 'package:frontend/shared/exceptions/user_not_found_exception.dart';
import 'package:frontend/data/models/responses/verification_code_ttl/verification_code_ttl.dart';

class LocalDataService {
  Result<List<Post>> getFeed() {
    return Result.ok(mockFeed);
  }

  Future<Result<User>> getUser() async {
    logger.d('Retrieving user');
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

  Future<(Uri, OAuthContext)> getOAuthAuthorizationURI(
    OAuthClient client,
    String identity,
  ) async {
    return oauth_shared.getOAuthAuthorizationURI(client, identity);
  }

  Future<OAuthSession> generateSession(
    OAuthClient client,
    String callback,
  ) async {
    return oauth_shared.generateSession(client, callback);
  }

  Future<(OAuthSession, ATProto)> refreshSession(OAuthClient client) async {
    return oauth_shared.refreshSession(client);
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

      if (result.statusCode == 429) {
        throw VerificationCodeAlreadySetException(result.body);
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
