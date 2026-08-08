import 'package:flutter_test/flutter_test.dart';
import 'package:huly_mobile/core/models/login_info.dart';
import 'package:huly_mobile/features/auth/auth_provider.dart';

void main() {
  group('AuthState', () {
    test('default state is unauthenticated', () {
      const state = AuthState();
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.serverUrl, isNull);
      expect(state.loginInfo, isNull);
      expect(state.workspaceLogin, isNull);
      expect(state.loading, false);
      expect(state.error, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      const state = AuthState(
        status: AuthStatus.loggedIn,
        serverUrl: 'https://huly.example.com',
      );
      final updated = state.copyWith(loading: true);
      expect(updated.status, AuthStatus.loggedIn);
      expect(updated.serverUrl, 'https://huly.example.com');
      expect(updated.loading, true);
    });

    test('copyWith clears error when set to null', () {
      const state = AuthState(error: 'something went wrong');
      final updated = state.copyWith(error: null);
      expect(updated.error, isNull);
    });
  });

  group('LoginInfo model', () {
    test('fromJson parses correctly', () {
      final info = LoginInfo.fromJson({
        'token': 'abc',
        'account': 'acc-1',
      });
      expect(info.token, 'abc');
      expect(info.accountId, 'acc-1');
      expect(info.tfaRequired, false);
    });

    test('fromJson with tfaRequired', () {
      final info = LoginInfo.fromJson({
        'token': 'abc',
        'account': 'acc-1',
        'tfaRequired': true,
      });
      expect(info.tfaRequired, true);
    });
  });

  group('WorkspaceLoginInfo model', () {
    test('fromJson parses correctly', () {
      final info = WorkspaceLoginInfo.fromJson({
        'token': 'ws-tok',
        'endpoint': 'wss://ws.example.com',
        'workspace': 'ws-123',
      });
      expect(info.token, 'ws-tok');
      expect(info.endpoint, 'wss://ws.example.com');
      expect(info.workspaceId, 'ws-123');
      expect(info.workspaceUrl, isNull);
    });
  });
}
