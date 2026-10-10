import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/realtime_provider.dart';
import '../../core/models/activity.dart';
import '../../core/models/channel.dart';
import '../auth/auth_provider.dart';

/// Fetches all channels the user can see.
/// Auto-refreshes when WebSocket Tx events arrive.
final channelsProvider = FutureProvider<List<Channel>>((ref) async {
  ref.watch(dataVersionProvider);
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final channels = await client.findAll('chunter:class:Channel');
  final dms = await client.findAll('chunter:class:DirectMessage');
  return [...channels, ...dms]
      .map((e) => Channel.fromJson(e))
      .toList()
    ..sort((a, b) => (b.modifiedOn ?? 0).compareTo(a.modifiedOn ?? 0));
});

/// Fetches messages for a given channel/DM.
/// Auto-refreshes when WebSocket Tx events arrive.
final channelMessagesProvider =
    FutureProvider.family<List<ChatMessage>, String>((ref, channelId) async {
  ref.watch(dataVersionProvider);
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final results = await client.findAll(
    'chunter:class:ChatMessage',
    query: {'attachedTo': channelId},
    options: {'sort': {'createdOn': 1}, 'limit': 200},
  );
  return results.map((e) => ChatMessage.fromJson(e)).toList();
});
