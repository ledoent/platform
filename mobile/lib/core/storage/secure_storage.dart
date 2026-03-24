import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists authentication tokens and server URL securely.
class SecureStorageService {
  static const _keyServerUrl = 'server_url';
  static const _keyAccountsUrl = 'accounts_url';
  static const _keyToken = 'token';
  static const _keyWorkspaceId = 'workspace_id';
  static const _keyWorkspaceToken = 'workspace_token';
  static const _keyWorkspaceEndpoint = 'workspace_endpoint';
  static const _keyWorkspaceUrl = 'workspace_url';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveServerUrl(String url) =>
      _storage.write(key: _keyServerUrl, value: url);
  Future<String?> getServerUrl() => _storage.read(key: _keyServerUrl);

  Future<void> saveAccountsUrl(String url) =>
      _storage.write(key: _keyAccountsUrl, value: url);
  Future<String?> getAccountsUrl() => _storage.read(key: _keyAccountsUrl);

  Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);
  Future<String?> getToken() => _storage.read(key: _keyToken);

  Future<void> saveWorkspaceSession({
    required String workspaceId,
    required String token,
    required String endpoint,
    String? workspaceUrl,
  }) async {
    await _storage.write(key: _keyWorkspaceId, value: workspaceId);
    await _storage.write(key: _keyWorkspaceToken, value: token);
    await _storage.write(key: _keyWorkspaceEndpoint, value: endpoint);
    if (workspaceUrl != null) {
      await _storage.write(key: _keyWorkspaceUrl, value: workspaceUrl);
    }
  }

  Future<({String id, String token, String endpoint, String? url})?>
      getWorkspaceSession() async {
    final id = await _storage.read(key: _keyWorkspaceId);
    final token = await _storage.read(key: _keyWorkspaceToken);
    final endpoint = await _storage.read(key: _keyWorkspaceEndpoint);
    if (id == null || token == null || endpoint == null) return null;
    final url = await _storage.read(key: _keyWorkspaceUrl);
    return (id: id, token: token, endpoint: endpoint, url: url);
  }

  Future<void> clearAll() => _storage.deleteAll();
}
