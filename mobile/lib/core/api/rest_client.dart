import 'dart:convert';
import 'package:dio/dio.dart';

/// REST client for the Huly transactor API (/api/v1/*).
class HulyRestClient {
  final Dio _dio;
  final String baseUrl;
  final String workspaceId;
  final String token;

  HulyRestClient({
    required String endpoint,
    required this.workspaceId,
    required this.token,
    Dio? dio,
  })  : baseUrl = endpoint
            .replaceFirst('ws://', 'http://')
            .replaceFirst('wss://', 'https://'),
        _dio = dio ?? Dio() {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  String _apiPath(String path) => '$baseUrl/api/v1/$path/$workspaceId';

  /// Query documents by class with optional query and options.
  Future<List<Map<String, dynamic>>> findAll(
    String className, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? options,
  }) async {
    final params = <String, String>{
      'class': className,
    };
    if (query != null) {
      params['query'] = jsonEncode(query);
    }
    if (options != null) {
      params['options'] = jsonEncode(options);
    }

    final response = await _dio.get(
      _apiPath('find-all'),
      queryParameters: params,
    );

    _checkRateLimit(response);

    final data = response.data;
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Submit a transaction.
  Future<Map<String, dynamic>> tx(Map<String, dynamic> txBody) async {
    final response = await _dio.post(
      _apiPath('tx'),
      data: txBody,
    );
    _checkRateLimit(response);
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {};
  }

  /// Get current account info.
  Future<Map<String, dynamic>> getAccount() async {
    final response = await _dio.get(_apiPath('account'));
    _checkRateLimit(response);
    return response.data as Map<String, dynamic>;
  }

  void _checkRateLimit(Response response) {
    if (response.statusCode == 429) {
      final retryAfter = response.headers.value('Retry-After');
      throw RateLimitException(
        retryAfterSeconds: int.tryParse(retryAfter ?? '') ?? 60,
      );
    }
  }
}

class RateLimitException implements Exception {
  final int retryAfterSeconds;
  RateLimitException({required this.retryAfterSeconds});

  @override
  String toString() => 'Rate limited. Retry after $retryAfterSeconds seconds.';
}

