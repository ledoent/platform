import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huly_mobile/core/api/rest_client.dart';
import 'package:huly_mobile/core/models/activity.dart';
import 'package:huly_mobile/core/models/attachment.dart';
import 'package:huly_mobile/core/models/issue.dart';
import 'package:huly_mobile/core/models/issue_status.dart';
import 'package:huly_mobile/core/models/member.dart';
import 'package:huly_mobile/features/auth/auth_provider.dart';
import 'package:huly_mobile/features/issues/issue_detail_screen.dart';
import 'package:huly_mobile/features/issues/issue_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockRestClient extends Mock implements HulyRestClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('IssueDetailScreen', () {
    late MockRestClient mockRestClient;

    setUp(() {
      mockRestClient = MockRestClient();
    });

    testWidgets('shows loading indicator', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            issueDetailProvider('i1').overrideWith((ref) => Completer<Issue?>().future),
          ],
          child: const MaterialApp(home: IssueDetailScreen(issueId: 'i1')),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows issue details and components', (tester) async {
      final issue = Issue(
        id: 'i1',
        className: 'tracker:class:Issue',
        title: 'Detailed Issue',
        priority: 1,
        number: 1,
        identifier: 'P1-1',
        status: 'open',
        space: 'p1',
        description: '<p>Some description</p>',
        assignee: 'u1',
      );

      final members = {
        'u1': const Member(id: 'u1', name: 'Alice'),
      };

      final statuses = [
        const IssueStatus(id: 'open', name: 'Open'),
      ];

      final attachments = [
        const Attachment(
          id: 'a1',
          name: 'test.jpg',
          size: 1024,
          type: 'image/jpeg',
          file: 'blob1',
          attachedTo: 'i1',
        ),
      ];

      final messages = [
        ChatMessage(
          id: 'm1',
          className: 'chunter:class:ChatMessage',
          attachedTo: 'i1',
          message: '<p>Comment 1</p>',
          createdBy: 'u1',
          createdOn: 1000,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            issueDetailProvider('i1').overrideWith((ref) => issue),
            issueStatusesProvider.overrideWith((ref) => statuses),
            membersProvider.overrideWith((ref) => members),
            activityProvider('i1').overrideWith((ref) => messages),
            attachmentsProvider('i1').overrideWith((ref) => attachments),
          ],
          child: const MaterialApp(home: IssueDetailScreen(issueId: 'i1')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('P1-1'), findsOneWidget);
      expect(find.text('Detailed Issue'), findsOneWidget);
      expect(find.text('Alice'), findsWidgets);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('Some description'), findsOneWidget);
      expect(find.text('test.jpg'), findsOneWidget);
      expect(find.text('Comment 1'), findsOneWidget);
    });

    testWidgets('posts a comment', (tester) async {
      final issue = Issue(
        id: 'i1',
        className: 'tracker:class:Issue',
        title: 'Detailed Issue',
        priority: 1,
        number: 1,
        identifier: 'P1-1',
        status: 'open',
        space: 'p1',
      );

      when(() => mockRestClient.tx(any())).thenAnswer((_) async => <String, dynamic>{});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            issueDetailProvider('i1').overrideWith((ref) => issue),
            issueStatusesProvider.overrideWith((ref) => []),
            membersProvider.overrideWith((ref) => {}),
            activityProvider('i1').overrideWith((ref) => []),
            attachmentsProvider('i1').overrideWith((ref) => []),
            restClientProvider.overrideWithValue(mockRestClient),
          ],
          child: const MaterialApp(home: IssueDetailScreen(issueId: 'i1')),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'New comment');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      verify(() => mockRestClient.tx(any())).called(1);
      expect(find.text('New comment'), findsNothing);
    });
  });
}
