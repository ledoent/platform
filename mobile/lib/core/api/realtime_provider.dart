import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/auth_provider.dart';
import 'websocket_client.dart';

/// Provides a connected WebSocket client when a workspace is selected.
final wsClientProvider = Provider<HulyWebSocketClient?>((ref) {
  final auth = ref.watch(authProvider);
  final ws = auth.workspaceLogin;
  if (ws == null || auth.status != AuthStatus.workspaceSelected) return null;

  final client = HulyWebSocketClient(
    endpoint: ws.endpoint,
    token: ws.token,
  );

  client.connect().catchError((_) {});
  ref.onDispose(() => client.close());

  return client;
});

/// Increments whenever a Tx event is received via WebSocket.
/// Providers can watch this to auto-refresh when data changes.
final dataVersionProvider = StateProvider<int>((ref) => 0);

/// Starts listening for Tx events and bumps dataVersionProvider.
/// Call this once from your root widget.
void startRealtimeListener(dynamic ref) {
  final HulyWebSocketClient? client;
  final StateController<int> notifier;

  if (ref is WidgetRef) {
    client = ref.read(wsClientProvider);
    notifier = ref.read(dataVersionProvider.notifier);
  } else {
    return;
  }

  if (client == null) return;

  client.txStream.listen((_) {
    notifier.state++;
  });
}
