import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/widgets/huly_button.dart';
import 'auth_provider.dart';

class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final workspaces = auth.workspaces ?? [];

    return Scaffold(
      backgroundColor: HulyColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                'Select Workspace',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (auth.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    auth.error!,
                    style: const TextStyle(color: HulyColors.errorText),
                  ),
                ),
              if (auth.loading)
                const Center(child: CircularProgressIndicator())
              else if (workspaces.isEmpty)
                const Text(
                  'No workspaces found.',
                  style: TextStyle(color: HulyColors.darkText),
                  textAlign: TextAlign.center,
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: workspaces.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final ws = workspaces[index];
                      return _WorkspaceTile(
                        name: ws.workspaceName,
                        url: ws.workspaceUrl,
                        onTap: () => ref
                            .read(authProvider.notifier)
                            .selectWorkspace(ws.workspaceUrl),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              HulyButton(
                label: 'Sign out',
                kind: HulyButtonKind.ghost,
                onPressed: () => ref.read(authProvider.notifier).logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkspaceTile extends StatelessWidget {
  final String name;
  final String url;
  final VoidCallback onTap;

  const _WorkspaceTile({
    required this.name,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate initials for avatar
    final initials = name.isNotEmpty
        ? name
            .split(' ')
            .take(2)
            .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
            .join()
        : '?';

    return Material(
      color: HulyColors.listRow,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: HulyColors.primaryButton,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: HulyColors.contentText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      url,
                      style: const TextStyle(
                        color: HulyColors.darkerText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: HulyColors.darkerText,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
