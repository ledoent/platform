import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/channel.dart';
import '../../core/models/member.dart';
import '../../core/theme/huly_theme.dart';
import '../issues/issue_provider.dart';
import 'chat_provider.dart';

class ChannelListScreen extends ConsumerWidget {
  const ChannelListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider);
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      backgroundColor: HulyColors.background,
      appBar: AppBar(
        backgroundColor: HulyColors.header,
        title: const Text('Chat'),
      ),
      body: channelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: HulyColors.errorText)),
        ),
        data: (channels) {
          if (channels.isEmpty) {
            return const Center(
              child: Text('No channels or DMs.',
                  style: TextStyle(color: HulyColors.darkText)),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(channelsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: channels.length,
              itemBuilder: (context, index) {
                final channel = channels[index];
                return _ChannelTile(
                  channel: channel,
                  members: membersAsync.valueOrNull,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ChannelTile extends StatelessWidget {
  final Channel channel;
  final Map<String, Member>? members;

  const _ChannelTile({required this.channel, this.members});

  bool get _isDm => channel.className.contains('DirectMessage');

  String get _displayName {
    if (channel.name.isNotEmpty) return channel.name;
    if (_isDm && members != null) {
      final names = channel.members
          .map((id) => members![id]?.name ?? id)
          .take(3)
          .join(', ');
      return names.isNotEmpty ? names : 'Direct Message';
    }
    return _isDm ? 'Direct Message' : 'Channel';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: HulyColors.listRow,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.push('/chat/${channel.id}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  _isDm ? Icons.person_outline : Icons.tag,
                  color: HulyColors.darkText,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _displayName,
                    style: const TextStyle(
                      color: HulyColors.contentText,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
