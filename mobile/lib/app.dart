import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/huly_theme.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/server_url_screen.dart';
import 'features/auth/tfa_screen.dart';
import 'features/auth/workspace_screen.dart';
import 'features/create_issue/create_issue_screen.dart';
import 'features/issues/issue_detail_screen.dart';
import 'features/issues/issue_list_screen.dart';

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

      // Workspace selected — allow any route; redirect root to /issues.
      if (path == '/server' || path == '/login' || path == '/tfa' || path == '/workspace') {
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
      GoRoute(path: '/issues', builder: (_, __) => const IssueListScreen()),
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
