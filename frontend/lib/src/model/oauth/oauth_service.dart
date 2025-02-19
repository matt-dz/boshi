import 'dart:convert';

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
    String clientId,
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
}
