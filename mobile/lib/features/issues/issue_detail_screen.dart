import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/activity.dart';
import '../../core/models/issue.dart';
import '../../core/models/issue_status.dart';
import '../../core/models/member.dart';
import '../../core/models/tx.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/utils/html.dart';
import '../../core/widgets/huly_chip.dart';
import '../../core/widgets/message_bubble.dart';
import '../../core/widgets/priority_icon.dart';
import '../auth/auth_provider.dart';
import 'edit_issue_screen.dart';
import 'issue_provider.dart';

/// Fetches a single issue by ID.
final issueDetailProvider =
    FutureProvider.family<Issue?, String>((ref, issueId) async {
  final client = ref.watch(restClientProvider);
  if (client == null) return null;
  final results = await client.findAll(
    'tracker:class:Issue',
    query: {'_id': issueId},
  );
  if (results.isEmpty) return null;
  return Issue.fromJson(results.first);
});

class IssueDetailScreen extends ConsumerStatefulWidget {
  final String issueId;
  const IssueDetailScreen({super.key, required this.issueId});

  @override
  ConsumerState<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends ConsumerState<IssueDetailScreen> {
  final _commentController = TextEditingController();
  bool _sendingComment = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _sendingComment = true);
    try {
      final client = ref.read(restClientProvider);
      if (client == null) return;

      final tx = buildCreateChatMessageTx(
        channelId: widget.issueId,
        message: '<p>${escapeHtml(text)}</p>',
      );
      await client.tx(tx);
      _commentController.clear();
      ref.invalidate(activityProvider(widget.issueId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post comment: $e'),
            backgroundColor: HulyColors.negative,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sendingComment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final issueAsync = ref.watch(issueDetailProvider(widget.issueId));
    final statusesAsync = ref.watch(issueStatusesProvider);
    final membersAsync = ref.watch(membersProvider);
    final activityAsync = ref.watch(activityProvider(widget.issueId));

    return Scaffold(
      backgroundColor: HulyColors.background,
      appBar: AppBar(
        backgroundColor: HulyColors.header,
        actions: [
          if (issueAsync.valueOrNull != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        EditIssueScreen(issue: issueAsync.valueOrNull!),
                  ),
                );
              },
            ),
        ],
      ),
      body: issueAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: HulyColors.errorText)),
        ),
        data: (issue) {
          if (issue == null) {
            return const Center(
              child: Text('Issue not found.',
                  style: TextStyle(color: HulyColors.darkText)),
            );
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.identifier,
                  style: const TextStyle(
                    color: HulyColors.darkerText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  issue.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Property chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    HulyChip(
                      label: PriorityIcon.label(issue.priority),
                      color: HulyColors.priorityColor(issue.priority),
                      icon: _priorityIcon(issue.priority),
                    ),
                    HulyChip(
                      label: _resolveStatusName(
                          issue.status, statusesAsync.valueOrNull),
                      color: HulyColors.accent,
                    ),
                    if (issue.assignee != null)
                      HulyChip(
                        label: _resolveMemberName(
                            issue.assignee!, membersAsync.valueOrNull),
                        icon: Icons.person_outline,
                      ),
                  ],
                ),

                if (issue.description != null &&
                    issue.description!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Divider(color: HulyColors.divider),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: HulyColors.darkText,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stripHtml(issue.description!),
                    style: const TextStyle(
                      color: HulyColors.contentText,
                      height: 1.5,
                    ),
                  ),
                ],
                // Activity / comments
                const SizedBox(height: 24),
                const Divider(color: HulyColors.divider),
                const SizedBox(height: 16),
                const Text(
                  'Activity',
                  style: TextStyle(
                    color: HulyColors.darkText,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                _ActivityFeed(
                  activityAsync: activityAsync,
                  members: membersAsync.valueOrNull,
                ),
              ],
            ),
          ),
              ),
              // Comment input bar
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                decoration: const BoxDecoration(
                  color: HulyColors.header,
                  border:
                      Border(top: BorderSide(color: HulyColors.divider)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: const TextStyle(
                              color: HulyColors.darkerText),
                          filled: true,
                          fillColor: HulyColors.inputFill,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                        style: const TextStyle(
                            color: HulyColors.contentText),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _postComment(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed:
                          _sendingComment ? null : _postComment,
                      icon: _sendingComment
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            )
                          : Icon(Icons.send,
                              color: HulyColors.accent),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _resolveMemberName(String ref, Map<String, Member>? members) {
    if (members == null) return ref;
    return members[ref]?.name ?? ref;
  }

  String _resolveStatusName(String statusRef, List<IssueStatus>? statuses) {
    if (statuses == null) return statusRef;
    final match = statuses.where((s) => s.id == statusRef);
    return match.isNotEmpty ? match.first.name : statusRef;
  }

  IconData _priorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icons.keyboard_double_arrow_up;
      case 2:
        return Icons.keyboard_arrow_up;
      case 3:
        return Icons.remove;
      case 4:
        return Icons.keyboard_arrow_down;
      default:
        return Icons.more_horiz;
    }
  }
}

class _ActivityFeed extends StatelessWidget {
  final AsyncValue<List<ChatMessage>> activityAsync;
  final Map<String, Member>? members;

  const _ActivityFeed({required this.activityAsync, this.members});

  String _resolveAuthor(String? ref) {
    if (ref == null) return 'Unknown';
    if (members == null) return ref;
    return members![ref]?.name ?? ref;
  }

  @override
  Widget build(BuildContext context) {
    return activityAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Error loading activity: $e',
          style: const TextStyle(color: HulyColors.errorText, fontSize: 12)),
      data: (messages) {
        if (messages.isEmpty) {
          return const Text('No comments yet.',
              style: TextStyle(color: HulyColors.darkerText, fontSize: 13));
        }
        return Column(
          children: messages
              .map((msg) => MessageBubble(
                    authorName:
                        _resolveAuthor(msg.createdBy ?? msg.modifiedBy),
                    messageHtml: msg.message,
                    timestamp: msg.createdOn ?? msg.modifiedOn,
                  ))
              .toList(),
        );
      },
    );
  }
}
