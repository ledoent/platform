import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huly_mobile/core/api/account_client.dart';
import 'package:huly_mobile/core/models/login_info.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  late MockDio mockDio;
  late AccountClient client;

  setUp(() {
    mockDio = MockDio();
    client = AccountClient(accountsUrl: 'https://example.com/accounts', dio: mockDio);
    registerFallbackValue(Options());
  });

  group('AccountClient', () {
    test('login returns LoginInfo on success', () async {
      final response = MockResponse<dynamic>();
      when(() => response.data).thenReturn({
        'result': {
          'token': 'test-token',
          'account': 'acc-123',
        },
      });
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => response);

      final result = await client.login('test@example.com', 'password');

      expect(result, isA<LoginInfo>());
      expect(result.token, 'test-token');
      expect(result.accountId, 'acc-123');
      expect(result.tfaRequired, false);
    });

    test('login throws AccountRpcError on error response', () async {
      final response = MockResponse<dynamic>();
      when(() => response.data).thenReturn({
        'error': {
          'code': 401,
          'message': 'Invalid credentials',
        },
      });
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => response);

      expect(
        () => client.login('test@example.com', 'wrong'),
        throwsA(isA<AccountRpcError>()),
      );
    });

    test('getUserWorkspaces returns list', () async {
      client.setToken('test-token');
      final response = MockResponse<dynamic>();
      when(() => response.data).thenReturn({
        'result': [
          {
            'workspaceUrl': 'my-workspace',
            'workspaceName': 'My Workspace',
          },
        ],
      });
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => response);

      final workspaces = await client.getUserWorkspaces();

      expect(workspaces, hasLength(1));
      expect(workspaces.first.workspaceName, 'My Workspace');
      expect(workspaces.first.workspaceUrl, 'my-workspace');
    });

    test('selectWorkspace returns WorkspaceLoginInfo', () async {
      client.setToken('test-token');
      final response = MockResponse<dynamic>();
      when(() => response.data).thenReturn({
        'result': {
          'token': 'ws-token',
          'endpoint': 'wss://ws.example.com',
          'workspace': 'ws-123',
        },
      });
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => response);

      final wsLogin = await client.selectWorkspace('my-workspace');

      expect(wsLogin.token, 'ws-token');
      expect(wsLogin.endpoint, 'wss://ws.example.com');
      expect(wsLogin.workspaceId, 'ws-123');
    });
  });

  group('getAccountsUrl', () {
    test('extracts ACCOUNTS_URL from config.json', () async {
      final dio = MockDio();
      final response = MockResponse<dynamic>();
      when(() => response.data).thenReturn({
        'ACCOUNTS_URL': 'https://example.com/accounts',
      });
      when(() => dio.get(any())).thenAnswer((_) async => response);

      final url = await AccountClient.getAccountsUrl('https://example.com', dio: dio);

      expect(url, 'https://example.com/accounts');
    });

    test('throws when ACCOUNTS_URL missing', () async {
      final dio = MockDio();
      final response = MockResponse<dynamic>();
      when(() => response.data).thenReturn({});
      when(() => dio.get(any())).thenAnswer((_) async => response);

      expect(
        () => AccountClient.getAccountsUrl('https://example.com', dio: dio),
        throwsA(isA<Exception>()),
      );
    });
  });
}
