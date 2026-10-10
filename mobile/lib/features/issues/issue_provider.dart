import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/realtime_provider.dart';
import '../../core/models/activity.dart';
import '../../core/models/attachment.dart';
import '../../core/models/issue.dart';
import '../../core/models/issue_status.dart';
import '../../core/models/member.dart';
import '../../core/models/project.dart';
import '../auth/auth_provider.dart';

/// Fetches projects from the tracker.
final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final results = await client.findAll('tracker:class:Project');
  return results.map((e) => Project.fromJson(e)).toList();
});

/// Fetches all tracker issue statuses.
final issueStatusesProvider =
    FutureProvider<List<IssueStatus>>((ref) async {
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final results = await client.findAll(
    'core:class:Status',
    query: {'ofAttribute': 'tracker:attribute:IssueStatus'},
  );
  return results.map((e) => IssueStatus.fromJson(e)).toList();
});

/// Fetches workspace members (contact:class:Person documents).
final membersProvider = FutureProvider<Map<String, Member>>((ref) async {
  final client = ref.watch(restClientProvider);
  if (client == null) return {};
  final results = await client.findAll('contact:class:Person');
  final members = results.map((e) => Member.fromJson(e)).toList();
  return {for (final m in members) m.id: m};
});

/// Fetches activity messages (comments) for a given document.
final activityProvider =
    FutureProvider.family<List<ChatMessage>, String>((ref, docId) async {
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final results = await client.findAll(
    'chunter:class:ChatMessage',
    query: {'attachedTo': docId},
    options: {'sort': {'createdOn': 1}, 'limit': 100},
  );
  return results.map((e) => ChatMessage.fromJson(e)).toList();
});

/// Fetches attachments for a given document.
final attachmentsProvider =
    FutureProvider.family<List<Attachment>, String>((ref, docId) async {
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final results = await client.findAll(
    'attachment:class:Attachment',
    query: {'attachedTo': docId},
  );
  return results.map((e) => Attachment.fromJson(e)).toList();
});

/// Fetches issues for a given project space ID.
/// Auto-refreshes when WebSocket Tx events arrive.
final issuesProvider =
    FutureProvider.family<List<Issue>, String>((ref, spaceId) async {
  ref.watch(dataVersionProvider);
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final results = await client.findAll(
    'tracker:class:Issue',
    query: {'space': spaceId},
    options: {'sort': {'modifiedOn': -1}, 'limit': 50},
  );
  return results.map((e) => Issue.fromJson(e)).toList();
});
