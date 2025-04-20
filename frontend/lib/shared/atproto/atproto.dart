import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:frontend/utils/result.dart';
import 'package:frontend/config/environment.dart';
import 'package:frontend/shared/exceptions/code_not_found_exception.dart';
import 'package:frontend/data/models/requests/verify_code/verify_code.dart';
import 'package:frontend/shared/exceptions/user_not_found_exception.dart';
import 'package:frontend/data/models/requests/add_email/add_email.dart';
import 'package:frontend/shared/exceptions/verification_code_already_set_exception.dart';
import 'package:frontend/data/models/responses/verification_status/verification_status.dart';
import 'package:frontend/data/models/responses/verification_code_ttl/verification_code_ttl.dart';
import 'package:frontend/utils/logger.dart';
import 'package:frontend/shared/exceptions/already_verified_exception.dart';

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
