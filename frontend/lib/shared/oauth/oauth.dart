import 'dart:convert';

import 'package:atproto/atproto.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:frontend/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const securePrefix = 'flutter.';

Future<void> _setSessionVars(
  OAuthSession session,
  SharedPreferences? prefs,
) async {
  prefs ??= await SharedPreferences.getInstance();
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

/// Initiate OAuth2 Authorization flow and store context in shared preferences
Future<(Uri, OAuthContext)> getOAuthAuthorizationURI(
  OAuthClient client,
  String identity,
) async {
  logger.d('Retrieving shared preferences instance');
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  logger.d('Initiating OAuth authorization request');
  final (uri, context) = await client.authorize(identity);

  logger.d('Setting OAuth variables');
  await prefs.setString('oauth-code-verifier', context.codeVerifier);
  await prefs.setString('oauth-state', context.state);
  await prefs.setString('oauth-dpop-nonce', context.dpopNonce);

  return (uri, context);
}

/// Generate OAuth2 session and store it in shared preferences
Future<OAuthSession> generateSession(
  OAuthClient client,
  String callback,
  bool secure,
) async {
  logger.d('Retrieving shared preferences instance');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();

  logger.d('Retrieving OAuth variables from storage');
  final codeVerifier = prefs.getString('oauth-code-verifier');
  final state = prefs.getString('oauth-state');
  final dpopNonce = prefs.getString('oauth-dpop-nonce');

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
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  logger.d('Retrieving OAuth session variables from shared preferences');
  final sessionVars = prefs.getString('session-vars');
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
