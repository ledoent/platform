import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huly_mobile/core/api/rest_client.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {
  @override
  BaseOptions get options => BaseOptions();

  @override
  set options(BaseOptions value) {}
}

void main() {
  group('HulyRestClient', () {
    test('converts ws:// endpoint to http://', () {
      final client = HulyRestClient(
        endpoint: 'ws://localhost:3333',
        workspaceId: 'ws-1',
        token: 'tok',
      );
      expect(client.baseUrl, 'http://localhost:3333');
    });

    test('converts wss:// endpoint to https://', () {
      final client = HulyRestClient(
        endpoint: 'wss://huly.example.com',
        workspaceId: 'ws-1',
        token: 'tok',
      );
      expect(client.baseUrl, 'https://huly.example.com');
    });

    test('leaves http:// endpoint unchanged', () {
      final client = HulyRestClient(
        endpoint: 'https://huly.example.com',
        workspaceId: 'ws-1',
        token: 'tok',
      );
      expect(client.baseUrl, 'https://huly.example.com');
    });
  });

  group('RateLimitException', () {
    test('toString includes retry time', () {
      final ex = RateLimitException(retryAfterSeconds: 30);
      expect(ex.toString(), contains('30'));
    });
  });
}
