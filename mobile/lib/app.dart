import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/huly_theme.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/lock_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/server_url_screen.dart';
import 'features/auth/tfa_screen.dart';
import 'features/auth/workspace_screen.dart';
import 'core/api/realtime_provider.dart';
import 'features/chat/channel_list_screen.dart';
import 'features/chat/message_thread_screen.dart';
import 'features/create_issue/create_issue_screen.dart';
import 'features/issues/issue_detail_screen.dart';
import 'features/issues/issue_list_screen.dart';
import 'features/settings/settings_screen.dart';

final _routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final path = state.uri.path;

      // No server URL set yet → server URL screen.
      if (auth.serverUrl == null || auth.accountsUrl == null) {
        return path == '/server' ? null : '/server';
      }

      // Not logged in → login screen.
      if (auth.status == AuthStatus.unauthenticated) {
        return path == '/login' ? null : '/login';
      }

      // OTP pending → stay on login (OTP entry shown there).
      if (auth.status == AuthStatus.otpPending) {
        return path == '/login' ? null : '/login';
      }

      // 2FA pending → TFA screen.
      if (auth.status == AuthStatus.tfaPending) {
        return path == '/tfa' ? null : '/tfa';
      }

      // Logged in but no workspace → workspace selection.
      if (auth.status == AuthStatus.loggedIn) {
        return path == '/workspace' ? null : '/workspace';
      }

      // Locked → biometric unlock screen.
      if (auth.status == AuthStatus.locked) {
        return path == '/locked' ? null : '/locked';
      }

      // Workspace selected — allow any route; redirect root to /issues.
      if (path == '/server' ||
          path == '/login' ||
          path == '/tfa' ||
          path == '/workspace' ||
          path == '/locked') {
        return '/issues';
      }
      if (path == '/') return '/issues';

      return null;
    },
    routes: [
      GoRoute(path: '/server', builder: (_, __) => const ServerUrlScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/tfa', builder: (_, __) => const TfaScreen()),
      GoRoute(path: '/workspace', builder: (_, __) => const WorkspaceScreen()),
      GoRoute(path: '/locked', builder: (_, __) => const LockScreen()),
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
              path: '/issues', builder: (_, __) => const IssueListScreen()),
          GoRoute(
              path: '/chat', builder: (_, __) => const ChannelListScreen()),
          GoRoute(
              path: '/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (_, state) => MessageThreadScreen(
          channelId: state.pathParameters['id']!,
          channelName: state.uri.queryParameters['name'],
        ),
      ),
      GoRoute(
        path: '/issue/:id',
        builder: (_, state) =>
            IssueDetailScreen(issueId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/create',
        builder: (_, state) {
          final extra = state.extra as Map<String, String?>?;
          return CreateIssueScreen(
            initialTitle: extra?['title'],
            initialDescription: extra?['description'],
          );
        },
      ),
    ],
  );
});

class _MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const _MainShell({required this.child});

  @override
  ConsumerState<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<_MainShell> {
  bool _realtimeStarted = false;

  @override
  Widget build(BuildContext context) {
    // Start WebSocket listener once.
    if (!_realtimeStarted) {
      _realtimeStarted = true;
      startRealtimeListener(ref);
    }

    final location = GoRouterState.of(context).uri.path;
    int index = 0;
    if (location.startsWith('/chat')) {
      index = 1;
    } else if (location.startsWith('/settings')) {
      index = 2;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: HulyColors.header,
        indicatorColor: HulyColors.primaryButton.withValues(alpha: 0.2),
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/issues');
            case 1:
              context.go('/chat');
            case 2:
              context.go('/settings');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Issues',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HulyApp extends ConsumerWidget {
  const HulyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);

    return MaterialApp.router(
      title: 'Huly',
      debugShowCheckedModeBanner: false,
      theme: hulyDarkTheme,
      routerConfig: router,
    );
  }
}
