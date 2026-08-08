import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/auth_provider.dart';
import '../../services/push_notification_service.dart';
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

  client.connect().then((_) {}).catchError((_) {});
  ref.onDispose(() => client.close());

  return client;
});

/// Increments whenever a Tx event is received via WebSocket.
/// Providers can watch this to auto-refresh when data changes.
final dataVersionProvider = StateProvider<int>((ref) => 0);

/// Push notification service singleton.
final pushServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService();
});

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

  // Register push notifications with workspace.
  _initPush(ref);
}

void _initPush(dynamic ref) async {
  if (ref is! WidgetRef) return;
  try {
    final push = ref.read(pushServiceProvider);
    await push.initialize();
    final restClient = ref.read(restClientProvider);
    if (restClient != null) {
      await push.registerWithWorkspace(restClient);
    }
  } catch (_) {
    // Firebase not configured — push disabled.
  }
}
