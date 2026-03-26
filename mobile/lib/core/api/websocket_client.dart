import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Real-time WebSocket client for the Huly transactor.
///
/// Implements the Huly protocol: HelloRequest/HelloResponse handshake,
/// ping/pong keep-alive, and Tx event streaming.
class HulyWebSocketClient {
  final String endpoint;
  final String token;
  final String? sessionId;

  WebSocketChannel? _channel;
  Timer? _pingTimer;
  int _requestId = 0;
  final _pendingRequests = <int, Completer<dynamic>>{};
  final _txController = StreamController<List<dynamic>>.broadcast();
  bool _connected = false;
  bool _disposed = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  /// Stream of incoming Tx arrays (real-time document changes).
  Stream<List<dynamic>> get txStream => _txController.stream;

  bool get isConnected => _connected;

  HulyWebSocketClient({
    required this.endpoint,
    required this.token,
    this.sessionId,
  });

  /// Connect to the WebSocket server and complete the handshake.
  Future<Map<String, dynamic>> connect() async {
    final wsUrl = endpoint
        .replaceFirst('http://', 'ws://')
        .replaceFirst('https://', 'wss://');
    final uri = Uri.parse('$wsUrl/$token')
        .replace(queryParameters: {if (sessionId != null) 'sessionId': sessionId!});

    _channel = WebSocketChannel.connect(uri);
    await _channel!.ready;

    // Send HelloRequest.
    _send({
      'id': -1,
      'method': 'hello',
      'params': [],
      'binary': false,
      'compression': false,
    });

    // Wait for HelloResponse.
    final helloCompleter = Completer<Map<String, dynamic>>();
    late StreamSubscription sub;
    sub = _channel!.stream.listen((data) {
      final msg = _decode(data);
      if (msg is Map<String, dynamic> && msg['id'] == -1) {
        sub.cancel();
        _connected = true;
        _reconnectAttempts = 0;
        _startListening();
        _startPingTimer();
        helloCompleter.complete(msg);
      }
    }, onError: (e) {
      if (!helloCompleter.isCompleted) {
        helloCompleter.completeError(e);
      }
    });

    return helloCompleter.future;
  }

  void _startListening() {
    _channel!.stream.listen(
      (data) => _handleMessage(_decode(data)),
      onDone: () {
        _connected = false;
        _pingTimer?.cancel();
        _failPendingRequests('Connection closed');
        _scheduleReconnect();
      },
      onError: (e) {
        _connected = false;
        _pingTimer?.cancel();
        _failPendingRequests('Connection error: $e');
        _scheduleReconnect();
      },
    );
  }

  void _handleMessage(dynamic msg) {
    if (msg is! Map<String, dynamic>) return;

    // Ping from server.
    if (msg['result'] == 'ping' && !msg.containsKey('id')) {
      _send({'method': 'ping', 'params': []});
      return;
    }

    // Response to a request.
    final id = msg['id'];
    if (id != null && id is int && _pendingRequests.containsKey(id)) {
      final completer = _pendingRequests.remove(id)!;
      if (msg.containsKey('error')) {
        completer.completeError(
            Exception(msg['error']?['message'] ?? 'Unknown error'));
      } else {
        completer.complete(msg['result']);
      }
      return;
    }

    // Unsolicited Tx broadcast (no id).
    if (!msg.containsKey('id') && msg.containsKey('result')) {
      final result = msg['result'];
      if (result is List) {
        _txController.add(result);
      } else if (result is Map) {
        _txController.add([result]);
      }
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_connected) {
        _send({'method': 'ping', 'params': []});
      }
    });
  }

  /// Send a request and wait for the response.
  Future<dynamic> request(String method, List<dynamic> params) {
    if (!_connected) {
      return Future.error(StateError('WebSocket not connected'));
    }
    final id = ++_requestId;
    final completer = Completer<dynamic>();
    _pendingRequests[id] = completer;
    _send({
      'id': id,
      'method': method,
      'params': params,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    return completer.future;
  }

  void _send(Map<String, dynamic> data) {
    _channel?.sink.add(jsonEncode(data));
  }

  dynamic _decode(dynamic data) {
    if (data is String) {
      if (data == 'ping') {
        return {'result': 'ping'};
      }
      return jsonDecode(data);
    }
    return data;
  }

  void _failPendingRequests(String reason) {
    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception(reason));
      }
    }
    _pendingRequests.clear();
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    final delay = Duration(seconds: (_reconnectAttempts++).clamp(0, 5));
    _reconnectTimer = Timer(delay, () {
      if (!_disposed) {
        connect().catchError((_) => _scheduleReconnect());
      }
    });
  }

  /// Disconnect and clean up.
  Future<void> close() async {
    _disposed = true;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _connected = false;
    _failPendingRequests('Client closed');
    await _channel?.sink.close();
    await _txController.close();
  }
}
