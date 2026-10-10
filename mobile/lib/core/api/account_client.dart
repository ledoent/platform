import 'package:dio/dio.dart';
import '../models/login_info.dart';

/// JSON-RPC client for the Huly accounts endpoint.
class AccountClient {
  final Dio _dio;
  final String accountsUrl;
  String? _token;

  AccountClient({required this.accountsUrl, Dio? dio})
      : _dio = dio ?? Dio();

  void setToken(String token) {
    _token = token;
  }

  /// Low-level JSON-RPC call to the accounts endpoint.
  Future<dynamic> _rpc(String method, List<dynamic> params) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    final response = await _dio.post(
      accountsUrl,
      data: {
        'method': method,
        'params': params,
      },
      options: Options(headers: headers),
    );

    final body = response.data;
    if (body is Map && body.containsKey('error')) {
      throw AccountRpcError(
        code: body['error']['code'] ?? -1,
        message: body['error']['message'] ?? 'Unknown error',
      );
    }
    return body['result'];
  }

  /// Fetch the accounts URL from the instance's config.json.
  static Future<String> getAccountsUrl(String serverUrl, {Dio? dio}) async {
    final client = dio ?? Dio();
    final url = serverUrl.endsWith('/')
        ? '${serverUrl}config.json'
        : '$serverUrl/config.json';
    final response = await client.get(url);
    final config = response.data;
    if (config is Map && config.containsKey('ACCOUNTS_URL')) {
      return config['ACCOUNTS_URL'] as String;
    }
    throw Exception('ACCOUNTS_URL not found in config.json');
  }

  /// Login with email and password.
  Future<LoginInfo> login(String email, String password) async {
    final result = await _rpc('login', [email, password, false]);
    final loginInfo = LoginInfo.fromJson(result as Map<String, dynamic>);
    _token = loginInfo.token;
    return loginInfo;
  }

  /// Request an OTP code sent to the given email.
  Future<OtpInfo> loginOtp(String email) async {
    final result = await _rpc('loginOtp', [email]);
    return OtpInfo.fromJson(result as Map<String, dynamic>);
  }

  /// Validate an OTP code and get a login token.
  Future<LoginInfo> validateOtp(String email, String code) async {
    final result = await _rpc('validateOtp', [email, code]);
    final loginInfo = LoginInfo.fromJson(result as Map<String, dynamic>);
    _token = loginInfo.token;
    return loginInfo;
  }

  /// Verify a 2FA/TOTP code using the partial token from login.
  /// Returns a full LoginInfo with a valid token.
  Future<LoginInfo> verify2fa(String partialToken, String code) async {
    final savedToken = _token;
    _token = partialToken;
    try {
      final result = await _rpc('verify2fa', [
        partialToken,
        {'code': code},
      ]);
      final loginInfo = LoginInfo.fromJson(result as Map<String, dynamic>);
      _token = loginInfo.token;
      return loginInfo;
    } catch (e) {
      _token = savedToken;
      rethrow;
    }
  }

  /// Get available OAuth providers (Google, GitHub, etc.)
  /// This is a REST GET endpoint, not an RPC call.
  Future<List<ProviderInfo>> getProviders() async {
    try {
      final url = accountsUrl.endsWith('/')
          ? '${accountsUrl}providers'
          : '$accountsUrl/providers';
      final response = await _dio.get(url);
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => ProviderInfo(
                  id: (e is Map ? e['name'] : e).toString(),
                  name: (e is Map ? e['name'] : e).toString(),
                ))
            .toList();
      }
    } catch (_) {
      // Instance may not have providers configured.
    }
    return [];
  }

  /// Get workspaces for the logged-in user.
  Future<List<WorkspaceInfo>> getUserWorkspaces() async {
    final result = await _rpc('getUserWorkspaces', []);
    return (result as List)
        .map((e) => WorkspaceInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Select a workspace and get connection info.
  Future<WorkspaceLoginInfo> selectWorkspace(String workspaceUrl) async {
    final result = await _rpc('selectWorkspace', [workspaceUrl, 'external']);
    return WorkspaceLoginInfo.fromJson(result as Map<String, dynamic>);
  }
}

class AccountRpcError implements Exception {
  final int code;
  final String message;

  AccountRpcError({required this.code, required this.message});

  @override
  String toString() => 'AccountRpcError($code): $message';
}
