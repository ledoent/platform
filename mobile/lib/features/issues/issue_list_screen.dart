import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/issue.dart';
import '../../core/models/project.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/widgets/priority_icon.dart';
import '../auth/auth_provider.dart';
import 'issue_provider.dart';

class IssueListScreen extends ConsumerStatefulWidget {
  const IssueListScreen({super.key});

  @override
  ConsumerState<IssueListScreen> createState() => _IssueListScreenState();
}

class _IssueListScreenState extends ConsumerState<IssueListScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  List<Project> _projects = [];
  Timer? _refreshTimer;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAllProjects();
      _startRefreshTimer();
    } else if (state == AppLifecycleState.paused) {
      _refreshTimer?.cancel();
    }
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      _refreshAllProjects();
    });
  }

  void _refreshAllProjects() {
    for (final project in _projects) {
      ref.invalidate(issuesProvider(project.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: HulyColors.background,
      appBar: AppBar(
        backgroundColor: HulyColors.header,
        title: const Text('Issues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: HulyColors.darkText),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create'),
        child: const Icon(Icons.add),
      ),
      body: projectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: HulyColors.errorText)),
        ),
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(
              child: Text('No projects found.',
                  style: TextStyle(color: HulyColors.darkText)),
            );
          }

          // Rebuild tab controller if projects changed.
          if (_projects.length != projects.length) {
            _tabController?.dispose();
            _tabController =
                TabController(length: projects.length, vsync: this);
            _projects = projects;
          }

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search issues...',
                    hintStyle: const TextStyle(color: HulyColors.darkerText),
                    prefixIcon: const Icon(Icons.search,
                        color: HulyColors.darkerText),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: HulyColors.darkerText),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: HulyColors.inputFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  style: const TextStyle(color: HulyColors.contentText),
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.trim()),
                ),
              ),
              Material(
                color: HulyColors.header,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: projects
                      .map((p) => Tab(text: p.identifier))
                      .toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: projects
                      .map((p) => _ProjectIssueList(
                            projectId: p.id,
                            searchQuery: _searchQuery,
                          ))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProjectIssueList extends ConsumerWidget {
  final String projectId;
  final String searchQuery;
  const _ProjectIssueList({
    required this.projectId,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuesAsync = ref.watch(issuesProvider(projectId));

    return issuesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Error: $e',
            style: const TextStyle(color: HulyColors.errorText)),
      ),
      data: (issues) {
        var filtered = issues;
        if (searchQuery.isNotEmpty) {
          final q = searchQuery.toLowerCase();
          filtered = issues
              .where((i) =>
                  i.title.toLowerCase().contains(q) ||
                  i.identifier.toLowerCase().contains(q))
              .toList();
        }
        if (filtered.isEmpty) {
          return Center(
            child: Text(
              searchQuery.isNotEmpty ? 'No matching issues.' : 'No issues.',
              style: const TextStyle(color: HulyColors.darkText),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(issuesProvider(projectId).future),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length,
            itemBuilder: (context, index) =>
                _IssueTile(issue: filtered[index]),
          ),
        );
      },
    );
  }
}

class _IssueTile extends StatelessWidget {
  final Issue issue;
  const _IssueTile({required this.issue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: HulyColors.listRow,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.push('/issue/${issue.id}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                PriorityIcon(priority: issue.priority, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issue.identifier,
                        style: const TextStyle(
                          color: HulyColors.darkerText,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        issue.title,
                        style: const TextStyle(
                          color: HulyColors.contentText,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
