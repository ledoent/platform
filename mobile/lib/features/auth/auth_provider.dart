import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/account_client.dart';
import '../../core/api/rest_client.dart';
import '../../core/models/login_info.dart';
import '../../core/storage/secure_storage.dart';

/// Auth state: unauthenticated → (otpPending | tfaPending) → loggedIn → workspaceSelected.
enum AuthStatus { unauthenticated, otpPending, tfaPending, loggedIn, workspaceSelected }

class AuthState {
  final AuthStatus status;
  final String? serverUrl;
  final String? accountsUrl;
  final LoginInfo? loginInfo;
  final List<WorkspaceInfo>? workspaces;
  final WorkspaceLoginInfo? workspaceLogin;
  final List<ProviderInfo>? providers;
  final String? otpEmail;
  final String? error;
  final bool loading;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.serverUrl,
    this.accountsUrl,
    this.loginInfo,
    this.workspaces,
    this.workspaceLogin,
    this.providers,
    this.otpEmail,
    this.error,
    this.loading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? serverUrl,
    String? accountsUrl,
    LoginInfo? loginInfo,
    List<WorkspaceInfo>? workspaces,
    WorkspaceLoginInfo? workspaceLogin,
    List<ProviderInfo>? providers,
    String? otpEmail,
    String? error,
    bool? loading,
  }) {
    return AuthState(
      status: status ?? this.status,
      serverUrl: serverUrl ?? this.serverUrl,
      accountsUrl: accountsUrl ?? this.accountsUrl,
      loginInfo: loginInfo ?? this.loginInfo,
      workspaces: workspaces ?? this.workspaces,
      workspaceLogin: workspaceLogin ?? this.workspaceLogin,
      providers: providers ?? this.providers,
      otpEmail: otpEmail ?? this.otpEmail,
      error: error,
      loading: loading ?? this.loading,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final SecureStorageService _storage;

  @override
  AuthState build() {
    _storage = SecureStorageService();
    // Try to restore session on next microtask.
    Future.microtask(() => restoreSession());
    return const AuthState();
  }

  AccountClient? _accountClient;

  AccountClient get accountClient {
    if (_accountClient == null) {
      throw StateError('Account client not initialized — set server URL first');
    }
    return _accountClient!;
  }

  /// Validate server URL by fetching config.json and extracting ACCOUNTS_URL.
  Future<void> setServerUrl(String url) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final accountsUrl = await AccountClient.getAccountsUrl(url);
      _accountClient = AccountClient(accountsUrl: accountsUrl);
      await _storage.saveServerUrl(url);
      await _storage.saveAccountsUrl(accountsUrl);

      // Fetch available OAuth providers.
      final providers = await _accountClient!.getProviders();

      state = state.copyWith(
        serverUrl: url,
        accountsUrl: accountsUrl,
        providers: providers,
        status: AuthStatus.unauthenticated,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: 'Could not connect to server: $e',
      );
    }
  }

  /// Login with email/password.
  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final loginInfo = await accountClient.login(email, password);
      if (loginInfo.tfaRequired) {
        state = state.copyWith(
          status: AuthStatus.tfaPending,
          loginInfo: loginInfo,
          loading: false,
        );
        return;
      }
      await _storage.saveToken(loginInfo.token);

      final workspaces = await accountClient.getUserWorkspaces();
      state = state.copyWith(
        status: AuthStatus.loggedIn,
        loginInfo: loginInfo,
        workspaces: workspaces,
        loading: false,
      );
    } on AccountRpcError catch (e) {
      state = state.copyWith(loading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Login failed: $e');
    }
  }

  /// Request OTP code for the given email.
  Future<void> requestOtp(String email) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await accountClient.loginOtp(email);
      state = state.copyWith(
        status: AuthStatus.otpPending,
        otpEmail: email,
        loading: false,
      );
    } on AccountRpcError catch (e) {
      state = state.copyWith(loading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Failed to send code: $e');
    }
  }

  /// Validate OTP code and complete login.
  Future<void> validateOtp(String code) async {
    final email = state.otpEmail;
    if (email == null) return;
    state = state.copyWith(loading: true, error: null);
    try {
      final loginInfo = await accountClient.validateOtp(email, code);
      await _storage.saveToken(loginInfo.token);

      final workspaces = await accountClient.getUserWorkspaces();
      state = state.copyWith(
        status: AuthStatus.loggedIn,
        loginInfo: loginInfo,
        workspaces: workspaces,
        loading: false,
      );
    } on AccountRpcError catch (e) {
      state = state.copyWith(loading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Invalid code: $e');
    }
  }

  /// Verify a 2FA/TOTP code to complete login.
  Future<void> verify2fa(String code) async {
    final partialToken = state.loginInfo?.token;
    if (partialToken == null) return;
    state = state.copyWith(loading: true, error: null);
    try {
      final loginInfo = await accountClient.verify2fa(partialToken, code);
      await _storage.saveToken(loginInfo.token);

      final workspaces = await accountClient.getUserWorkspaces();
      state = state.copyWith(
        status: AuthStatus.loggedIn,
        loginInfo: loginInfo,
        workspaces: workspaces,
        loading: false,
      );
    } on AccountRpcError catch (e) {
      state = state.copyWith(loading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Invalid 2FA code: $e');
    }
  }

  /// Handle token received from OAuth flow (Google, etc.)
  Future<void> loginWithToken(String token) async {
    state = state.copyWith(loading: true, error: null);
    try {
      _accountClient!.setToken(token);
      await _storage.saveToken(token);

      final workspaces = await accountClient.getUserWorkspaces();
      state = state.copyWith(
        status: AuthStatus.loggedIn,
        workspaces: workspaces,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: 'OAuth login failed: $e');
    }
  }

  /// Build an OAuth URL for in-app browser login.
  /// The providers endpoint is on the accounts URL (e.g. /_accounts/auth/google).
  String? getOAuthUrl(String provider) {
    final accountsUrl = state.accountsUrl;
    if (accountsUrl == null) return null;
    final base = accountsUrl.endsWith('/') ? accountsUrl : '$accountsUrl/';
    return '${base}auth/$provider';
  }

  /// Select a workspace.
  Future<void> selectWorkspace(String workspaceUrl) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final wsLogin = await accountClient.selectWorkspace(workspaceUrl);
      await _storage.saveWorkspaceSession(
        workspaceId: wsLogin.workspaceId,
        token: wsLogin.token,
        endpoint: wsLogin.endpoint,
        workspaceUrl: workspaceUrl,
      );
      state = state.copyWith(
        status: AuthStatus.workspaceSelected,
        workspaceLogin: wsLogin,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Workspace error: $e');
    }
  }

  /// Restore session from secure storage.
  Future<void> restoreSession() async {
    final serverUrl = await _storage.getServerUrl();
    final accountsUrl = await _storage.getAccountsUrl();
    if (serverUrl == null || accountsUrl == null) return;

    _accountClient = AccountClient(accountsUrl: accountsUrl);

    final token = await _storage.getToken();
    if (token == null) {
      state = state.copyWith(serverUrl: serverUrl, accountsUrl: accountsUrl);
      return;
    }
    _accountClient!.setToken(token);

    final ws = await _storage.getWorkspaceSession();
    if (ws != null) {
      state = state.copyWith(
        serverUrl: serverUrl,
        accountsUrl: accountsUrl,
        status: AuthStatus.workspaceSelected,
        workspaceLogin: WorkspaceLoginInfo(
          token: ws.token,
          endpoint: ws.endpoint,
          workspaceId: ws.id,
          workspaceUrl: ws.url,
        ),
      );
    } else {
      state = state.copyWith(
        serverUrl: serverUrl,
        accountsUrl: accountsUrl,
        status: AuthStatus.unauthenticated,
      );
    }
  }

  /// Logout and clear stored credentials.
  Future<void> logout() async {
    await _storage.clearAll();
    _accountClient = null;
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Provides a configured REST client when a workspace is selected.
final restClientProvider = Provider<HulyRestClient?>((ref) {
  final auth = ref.watch(authProvider);
  final ws = auth.workspaceLogin;
  if (ws == null) return null;
  return HulyRestClient(
    endpoint: ws.endpoint,
    workspaceId: ws.workspaceId,
    token: ws.token,
  );
});
