import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/internal/result/result.dart';

FutureOr<String?> localRouteGuard(
  BuildContext context,
  GoRouterState state,
) async {
  final oauth = context.read<AtProtoRepository>();
  if (oauth.authorized) {
    logger.d('user is authorized');
    return null;
  }

  logger.d('user not authorized, refreshing session...');
  var result = await oauth.refreshSession();
  if (result is Ok<void>) {
    logger.d('user is authorized');
    return null;
  }
  logger.e(result);
  logger.e('Failed to refresh session. Attempting to generate...');

  result = await oauth.generateSession(Uri.base.toString());
  if (result is Ok<void>) {
    logger.d('session generated');
    return null;
  }
  logger.e('Failed to generate session: ${result.toString()}');
  return '/login';
}

FutureOr<String?> prodRouteGuard(
  BuildContext context,
  GoRouterState state,
) async {
  final oauth = context.read<AtProtoRepository>();
  final isLoggingIn = state.uri.path.startsWith('/login');
  final onOAuthCallback = state.uri.path.startsWith('/oauth/callback');

  if (!oauth.authorized && !(isLoggingIn || onOAuthCallback)) {
    final result = await oauth.refreshSession();
    if (result is Error<void>) {
      return '/login';
    }
  } else if (oauth.authorized && isLoggingIn) {
    return '/';
  }
  return null;
}

FutureOr<String?> rootRouteGuard(
  BuildContext context,
  GoRouterState state,
) async {
  final atProto = context.read<AtProtoRepository>();
  final verified = await atProto.isUserVerified();
  switch (verified) {
    case Ok<bool>():
      if (!verified.value) {
        return '/signup';
      }
    case Error<bool>():
      print(verified.error.toString());
      return '/login';
  }
  return null;
}

FutureOr<String?> verifyEmailRouteGuard(
  BuildContext context,
  GoRouterState state,
) async {
  if (state.uri.queryParameters['email'] == null) {
    return '/signup';
  }
  return null;
}

FutureOr<String?> signupRouteGuard(
  BuildContext context,
  GoRouterState state,
) async {
  final atProto = context.read<AtProtoRepository>();
  final verified = await atProto.isUserVerified();
  switch (verified) {
    case Ok<bool>():
      if (verified.value) {
        return '/';
      }
    case Error<bool>():
      print(verified.error.toString());
      return '/login';
  }
  return null;
}
