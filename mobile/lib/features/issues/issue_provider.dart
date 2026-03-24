import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/issue.dart';
import '../../core/models/issue_status.dart';
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

/// Fetches issues for a given project space ID.
final issuesProvider =
    FutureProvider.family<List<Issue>, String>((ref, spaceId) async {
  final client = ref.watch(restClientProvider);
  if (client == null) return [];
  final results = await client.findAll(
    'tracker:class:Issue',
    query: {'space': spaceId},
    options: {'sort': {'modifiedOn': -1}, 'limit': 50},
  );
  return results.map((e) => Issue.fromJson(e)).toList();
});
