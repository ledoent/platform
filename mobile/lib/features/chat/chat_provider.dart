import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/activity.dart';
import '../../core/models/channel.dart';
import '../auth/auth_provider.dart';

/// Fetches all channels the user can see.
final channelsProvider = FutureProvider<List<Channel>>((ref) async {
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final channels = await client.findAll(
    'chunter:class:Channel',
    options: {'sort': {'modifiedOn': -1}},
  );
  final dms = await client.findAll(
    'chunter:class:DirectMessage',
    options: {'sort': {'modifiedOn': -1}},
  );
  return [...channels, ...dms]
      .map((e) => Channel.fromJson(e))
      .toList()
    ..sort((a, b) => (b.modifiedOn ?? 0).compareTo(a.modifiedOn ?? 0));
});

/// Fetches messages for a given channel/DM.
final channelMessagesProvider =
    FutureProvider.family<List<ChatMessage>, String>((ref, channelId) async {
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final results = await client.findAll(
    'chunter:class:ChatMessage',
    query: {'attachedTo': channelId},
    options: {'sort': {'createdOn': 1}, 'limit': 200},
  );
  return results.map((e) => ChatMessage.fromJson(e)).toList();
});
