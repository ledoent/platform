import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huly_mobile/core/models/issue.dart';
import 'package:huly_mobile/core/models/project.dart';
import 'package:huly_mobile/features/issues/issue_list_screen.dart';
import 'package:huly_mobile/features/issues/issue_provider.dart';

void main() {
  group('IssueListScreen', () {
    testWidgets('shows loading indicator while projects are loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => Completer<List<Project>>().future),
          ],
          child: const MaterialApp(home: IssueListScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message on failure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => Future.error('Failed to load')),
          ],
          child: const MaterialApp(home: IssueListScreen()),
        ),
      );

      await tester.pump(); // Let the error propagate

      expect(find.textContaining('Failed to load'), findsOneWidget);
    });

    testWidgets('shows project tabs and issues', (tester) async {
      final project = Project(
        id: 'p1',
        className: 'tracker:class:Project',
        name: 'Project One',
        identifier: 'P1',
      );

      final issue = Issue(
        id: 'i1',
        className: 'tracker:class:Issue',
        title: 'Fix the bug',
        priority: 1,
        number: 1,
        identifier: 'P1-1',
        status: 'open',
        space: 'p1',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => [project]),
            issuesProvider('p1').overrideWith((ref) => [issue]),
          ],
          child: const MaterialApp(home: IssueListScreen()),
        ),
      );

      // Wait for projects and issues to load
      await tester.pumpAndSettle();

      expect(find.text('P1'), findsWidgets); // Tab identifier
      expect(find.text('Fix the bug'), findsOneWidget);
      expect(find.text('P1-1'), findsOneWidget);
    });

    testWidgets('filters issues by search query', (tester) async {
      final project = Project(
        id: 'p1',
        className: 'tracker:class:Project',
        name: 'Project One',
        identifier: 'P1',
      );

      final issues = [
        Issue(
          id: 'i1',
          className: 'tracker:class:Issue',
          title: 'Apple',
          priority: 1,
          number: 1,
          identifier: 'P1-1',
          status: 'open',
          space: 'p1',
        ),
        Issue(
          id: 'i2',
          className: 'tracker:class:Issue',
          title: 'Banana',
          priority: 1,
          number: 2,
          identifier: 'P1-2',
          status: 'open',
          space: 'p1',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => [project]),
            issuesProvider('p1').overrideWith((ref) => issues),
          ],
          child: const MaterialApp(home: IssueListScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);

      // Type into search
      await tester.enterText(find.byType(TextField), 'app');
      await tester.pump();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
    });
  });
}
