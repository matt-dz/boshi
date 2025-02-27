import 'dart:convert';
import 'dart:js_interop';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/atproto.dart' as atp;
import 'package:atproto/core.dart';

class OAuthService {
  // Pulled from OAuthClient.
  Future<OAuthClientMetadata> getClientMetadata(final String clientId) async {
    if (clientId.isEmpty) throw ArgumentError.notNull(clientId);
    if (Uri.tryParse(clientId) == null) throw ArgumentError.value(clientId);

    final response = await http.get(Uri.parse(clientId));

    if (response.statusCode != 200) {
      throw OAuthException(
        'Failed to get client metadata: ${response.statusCode}',
      );
    }

    return OAuthClientMetadata.fromJson(jsonDecode(response.body));
  }

  Future<(Uri, OAuthContext)> getOAuthAuthorizationURI(
    OAuthClient client,
    String identity,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final (uri, context) = await client.authorize(identity);

      await prefs.setString('oauth-code-verifier', context.codeVerifier);
      await prefs.setString('oauth-state', context.state);
      await prefs.setString('oauth-dpop-nonce', context.dpopNonce);

      return (uri, context);
    } on UnauthorizedException {
      rethrow;
    } on XRPCException {
      rethrow;
    }
  }

  Future<(OAuthSession, atp.ATProto)> getOAuthSession(
    OAuthClient client,
    String callback,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final codeVerifier = prefs.getString("oauth-code-verifier");
      final state = prefs.getString("oauth-state");
      final dpopNonce = prefs.getString("oauth-dpop-nonce");

      if (codeVerifier != null && state != null && dpopNonce != null) {
        final context = OAuthContext(
          codeVerifier: codeVerifier,
          state: state,
          dpopNonce: dpopNonce,
        );

        final session = await client.callback(Uri.base.toString(), context);

        await setSessionVars(session);

        final atProtoSession = atp.ATProto.fromOAuthSession(session);
        return (session, atProtoSession);
      } else {
        throw ArgumentError("Context not set");
      }
    } on OAuthException {
      rethrow;
    } on ArgumentError {
      rethrow;
    }
  }

  Future<OAuthSession> getStoredOAuthSession() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionVars = prefs.getString('session-vars');
      if (sessionVars != null) {
        final sessionMap = json.decode(sessionVars);
        return OAuthSession(
            accessToken: sessionMap['accessToken'],
            refreshToken: sessionMap['refreshToken'],
            tokenType: sessionMap['tokenType'],
            scope: sessionMap['scope'],
            expiresAt: DateTime.parse(sessionMap['expiresAt']),
            sub: sessionMap['sub'],
            $dPoPNonce: sessionMap['\$dPoPNonce'],
            $publicKey: sessionMap['\$publicKey'],
            $privateKey: sessionMap['\$privateKey']);
      } else {
        throw ArgumentError("No session stored");
      }
    } on ArgumentError {
      rethrow;
    }
  }

  Future<void> setSessionVars(OAuthSession session) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("session-vars",
          "{\"accessToken\": \"${session.accessToken}\", \"refreshToken\": \"${session.refreshToken}\", \"tokenType\": \"${session.tokenType}\", \"scope\": \"${session.scope}\", \"expiresAt\": \"${session.expiresAt.toString()}\", \"sub\": \"${session.sub}\", \"\$dPoPNonce\": \"${session.$dPoPNonce}\", \"\$publicKey\": \"${session.$publicKey}\", \"\$privateKey\": \"${session.$privateKey}\"}");
    } catch (e) {
      rethrow;
    }
  }
}
