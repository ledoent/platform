import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/issue.dart';
import '../../core/models/issue_status.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/widgets/huly_chip.dart';
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

class IssueDetailScreen extends ConsumerWidget {
  final String issueId;
  const IssueDetailScreen({super.key, required this.issueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issueAsync = ref.watch(issueDetailProvider(issueId));
    final statusesAsync = ref.watch(issueStatusesProvider);

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
          return SingleChildScrollView(
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
                        label: issue.assignee!,
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
                    issue.description!
                        .replaceAll(RegExp(r'<[^>]*>'), '')
                        .trim(),
                    style: const TextStyle(
                      color: HulyColors.contentText,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
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
