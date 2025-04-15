import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/utils/logger.dart';
import 'package:frontend/utils/result.dart';

/// Route guard for general local redirects. A session will
/// be refreshed if the user is not authorized. If refreshing fails,
/// a new session will be generated as it is assumed that the
/// user is navigating from the oauth authorization request.
/// If refreshing and generation fails, the user is not authorized
/// and redirected to the login page.
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

/// General redirect logic for production environment. If the user
/// is not authorized and is attempting to navigate to a protected route,
/// they will be redirected to the login page.
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

/// If a user has not verified their email address, they are redirected
/// to the signup page.
FutureOr<String?> rootRouteGuard(
  BuildContext context,
  GoRouterState state,
) async {
  final atProto = context.read<AtProtoRepository>();
  final verified = await atProto.isUserVerified();
  logger.d(verified);
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

/// If email is not a query parameter, they are
/// redirected to the signup page.
FutureOr<String?> verifyEmailRouteGuard(
  BuildContext context,
  GoRouterState state,
) async {
  if (state.uri.queryParameters['email'] == null) {
    return '/signup';
  }
  return null;
}
