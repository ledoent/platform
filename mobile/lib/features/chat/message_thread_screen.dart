import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/tx.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/utils/html.dart';
import '../../core/widgets/message_bubble.dart';
import '../auth/auth_provider.dart';
import '../issues/issue_provider.dart';
import 'chat_provider.dart';

class MessageThreadScreen extends ConsumerStatefulWidget {
  final String channelId;
  final String? channelName;

  const MessageThreadScreen({
    super.key,
    required this.channelId,
    this.channelName,
  });

  @override
  ConsumerState<MessageThreadScreen> createState() =>
      _MessageThreadScreenState();
}

class _MessageThreadScreenState extends ConsumerState<MessageThreadScreen>
    with WidgetsBindingObserver {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _pollTimer;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startPoll();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(channelMessagesProvider(widget.channelId));
      _startPoll();
    } else if (state == AppLifecycleState.paused) {
      _pollTimer?.cancel();
    }
  }

  void _startPoll() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      ref.invalidate(channelMessagesProvider(widget.channelId));
    });
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);
    try {
      final client = ref.read(restClientProvider);
      if (client == null) return;

      final tx = buildCreateChatMessageTx(
        channelId: widget.channelId,
        message: '<p>${escapeHtml(text)}</p>',
      );
      await client.tx(tx);
      _messageController.clear();
      ref.invalidate(channelMessagesProvider(widget.channelId));

      // Scroll to bottom after a short delay for the rebuild.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send: $e'),
            backgroundColor: HulyColors.negative,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(channelMessagesProvider(widget.channelId));
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      backgroundColor: HulyColors.background,
      appBar: AppBar(
        backgroundColor: HulyColors.header,
        title: Text(widget.channelName ?? 'Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Error: $e',
                    style: const TextStyle(color: HulyColors.errorText)),
              ),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet.',
                        style: TextStyle(color: HulyColors.darkText)),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final author = msg.createdBy ?? msg.modifiedBy;
                    final members = membersAsync.valueOrNull;
                    final name = (members != null && author != null)
                        ? (members[author]?.name ?? author)
                        : (author ?? 'Unknown');

                    return MessageBubble(
                      authorName: name,
                      messageHtml: msg.message,
                      timestamp: msg.createdOn ?? msg.modifiedOn,
                      avatarRadius: 16,
                    );
                  },
                );
              },
            ),
          ),
          // Message input
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            decoration: const BoxDecoration(
              color: HulyColors.header,
              border: Border(top: BorderSide(color: HulyColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle:
                          const TextStyle(color: HulyColors.darkerText),
                      filled: true,
                      fillColor: HulyColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                    style: const TextStyle(color: HulyColors.contentText),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sending ? null : _send,
                  icon: _sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.send, color: HulyColors.accent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
