import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/issue.dart';
import '../../core/models/tx.dart';
import '../auth/auth_provider.dart';
import '../issues/issue_provider.dart';

class CreateIssueState {
  final bool loading;
  final String? error;
  final bool success;

  const CreateIssueState({
    this.loading = false,
    this.error,
    this.success = false,
  });
}

class CreateIssueNotifier extends Notifier<CreateIssueState> {
  @override
  CreateIssueState build() => const CreateIssueState();

  Future<bool> createIssue({
    required String space,
    required String title,
    required String status,
    int priority = IssuePriority.noPriority,
    String? description,
  }) async {
    state = const CreateIssueState(loading: true);
    try {
      final client = ref.read(restClientProvider);
      if (client == null) {
        state = const CreateIssueState(error: 'Not connected to workspace');
        return false;
      }

      final tx = buildCreateIssueTx(
        space: space,
        title: title,
        status: status,
        priority: priority,
        description: description,
      );

      await client.tx(tx);

      // Invalidate issue list so it refreshes.
      ref.invalidate(issuesProvider(space));

      state = const CreateIssueState(success: true);
      return true;
    } catch (e) {
      state = CreateIssueState(error: 'Failed to create issue: $e');
      return false;
    }
  }

  void reset() => state = const CreateIssueState();
}

final createIssueProvider =
    NotifierProvider<CreateIssueNotifier, CreateIssueState>(
        CreateIssueNotifier.new);
