import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

/// Performs OAuth login using ASWebAuthenticationSession (system browser).
///
/// Opens [url] in a secure system browser sheet. The server redirects to
/// `huly://login/auth?token=...` which is intercepted and returned.
///
/// Returns the token string on success, or null on failure/cancellation.
Future<String?> performOAuthLogin(String url) async {
  try {
    // Append mobileRedirect=huly so the server redirects to huly:// scheme
    final separator = url.contains('?') ? '&' : '?';
    final oauthUrl = '$url${separator}mobileRedirect=huly';

    final result = await FlutterWebAuth2.authenticate(
      url: oauthUrl,
      callbackUrlScheme: 'huly',
    );

    final uri = Uri.parse(result);

    // Check for error
    final error = uri.queryParameters['error'];
    if (error != null) return null;

    return uri.queryParameters['token'];
  } catch (_) {
    // User cancelled or auth failed
    return null;
  }
}
