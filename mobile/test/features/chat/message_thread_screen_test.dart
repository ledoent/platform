import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huly_mobile/core/api/rest_client.dart';
import 'package:huly_mobile/core/models/activity.dart';
import 'package:huly_mobile/core/models/member.dart';
import 'package:huly_mobile/features/auth/auth_provider.dart';
import 'package:huly_mobile/features/chat/chat_provider.dart';
import 'package:huly_mobile/features/chat/message_thread_screen.dart';
import 'package:huly_mobile/features/issues/issue_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockRestClient extends Mock implements HulyRestClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('MessageThreadScreen', () {
    late MockRestClient mockRestClient;

    setUp(() {
      mockRestClient = MockRestClient();
    });

    testWidgets('shows loading indicator', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            channelMessagesProvider('c1').overrideWith((ref) => Completer<List<ChatMessage>>().future),
            membersProvider.overrideWith((ref) => Completer<Map<String, Member>>().future),
          ],
          child: const MaterialApp(
            home: MessageThreadScreen(channelId: 'c1', channelName: 'General'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('shows messages and author names', (tester) async {
      final messages = [
        ChatMessage(
          id: 'm1',
          className: 'chunter:class:ChatMessage',
          attachedTo: 'c1',
          message: '<p>Hello world</p>',
          createdBy: 'u1',
          createdOn: 1000,
        ),
      ];

      final members = {
        'u1': const Member(id: 'u1', name: 'Alice'),
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            channelMessagesProvider('c1').overrideWith((ref) => messages),
            membersProvider.overrideWith((ref) => members),
          ],
          child: const MaterialApp(
            home: MessageThreadScreen(channelId: 'c1', channelName: 'General'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('General'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Hello world'), findsOneWidget);
    });

    testWidgets('sends a message', (tester) async {
      final messages = <ChatMessage>[];
      final members = <String, Member>{};

      when(() => mockRestClient.tx(any())).thenAnswer((_) async => <String, dynamic>{});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            channelMessagesProvider('c1').overrideWith((ref) => messages),
            membersProvider.overrideWith((ref) => members),
            restClientProvider.overrideWithValue(mockRestClient),
          ],
          child: const MaterialApp(
            home: MessageThreadScreen(channelId: 'c1', channelName: 'General'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'New message');
      await tester.tap(find.byIcon(Icons.send));
      
      // Wait for the tx response and the 300ms scroll timer
      await tester.pump(); // Start send
      await tester.pump(const Duration(milliseconds: 400)); // Finish scroll delay
      await tester.pumpAndSettle(); // Finish animations

      verify(() => mockRestClient.tx(any())).called(1);
      expect(find.text('New message'), findsNothing);
    });
  });
}
