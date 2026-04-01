import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:huly_mobile/core/api/rest_client.dart';
import 'package:huly_mobile/core/models/project.dart';
import 'package:huly_mobile/features/auth/auth_provider.dart';
import 'package:huly_mobile/features/create_issue/create_issue_screen.dart';
import 'package:huly_mobile/features/issues/issue_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockRestClient extends Mock implements HulyRestClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('CreateIssueScreen', () {
    late MockRestClient mockRestClient;

    setUp(() {
      mockRestClient = MockRestClient();
    });

    testWidgets('shows initial values and project picker', (tester) async {
      final project = Project(
        id: 'p1',
        className: 'tracker:class:Project',
        name: 'Project 1',
        identifier: 'P1',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => [project]),
          ],
          child: const MaterialApp(
            home: CreateIssueScreen(
              initialTitle: 'Bug',
              initialDescription: 'Broken',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Bug'), findsOneWidget);
      expect(find.text('Broken'), findsOneWidget);
      expect(find.text('Project 1'), findsOneWidget);
    });

    testWidgets('validates title is required', (tester) async {
      final project = Project(
        id: 'p1',
        className: 'tracker:class:Project',
        name: 'Project 1',
        identifier: 'P1',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => [project]),
          ],
          child: const MaterialApp(home: CreateIssueScreen()),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Create Issue'));
      await tester.pump();

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('submits form and calls API', (tester) async {
      final project = Project(
        id: 'p1',
        className: 'tracker:class:Project',
        name: 'Project 1',
        identifier: 'P1',
        defaultIssueStatus: 'open',
      );

      when(() => mockRestClient.tx(any())).thenAnswer((_) async => <String, dynamic>{});

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => const Scaffold(body: Text('Home'))),
          GoRoute(path: '/create', builder: (_, __) => const CreateIssueScreen()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => [project]),
            restClientProvider.overrideWithValue(mockRestClient),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      // Navigate to /create
      router.push('/create');
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'New Task');
      await tester.enterText(find.widgetWithText(TextFormField, 'Description'), 'Description text');
      
      await tester.tap(find.text('Create Issue'));
      await tester.pumpAndSettle();

      verify(() => mockRestClient.tx(any())).called(1);
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
