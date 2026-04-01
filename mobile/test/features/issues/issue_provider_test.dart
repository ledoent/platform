import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huly_mobile/core/api/rest_client.dart';
import 'package:huly_mobile/core/api/realtime_provider.dart';
import 'package:huly_mobile/features/auth/auth_provider.dart';
import 'package:huly_mobile/features/issues/issue_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockRestClient extends Mock implements HulyRestClient {}

void main() {
  group('IssueProvider', () {
    late MockRestClient mockRestClient;

    setUp(() {
      mockRestClient = MockRestClient();
    });

    ProviderContainer createContainer({
      List<Override> overrides = const [],
    }) {
      final container = ProviderContainer(overrides: overrides);
      addTearDown(container.dispose);
      return container;
    }

    test('projectsProvider fetches projects', () async {
      final container = createContainer(
        overrides: [
          restClientProvider.overrideWithValue(mockRestClient),
        ],
      );

      when(() => mockRestClient.findAll('tracker:class:Project')).thenAnswer(
        (_) async => [
          {
            '_id': 'p1',
            '_class': 'tracker:class:Project',
            'name': 'Project 1',
            'identifier': 'P1',
          },
        ],
      );

      final projects = await container.read(projectsProvider.future);
      expect(projects.length, 1);
      expect(projects[0].name, 'Project 1');
      expect(projects[0].id, 'p1');
    });

    test('issuesProvider fetches issues for space', () async {
      final container = createContainer(
        overrides: [
          restClientProvider.overrideWithValue(mockRestClient),
        ],
      );

      when(() => mockRestClient.findAll(
            'tracker:class:Issue',
            query: {'space': 's1'},
            options: {'sort': {'modifiedOn': -1}, 'limit': 50},
          )).thenAnswer(
        (_) async => [
          {
            '_id': 'i1',
            '_class': 'tracker:class:Issue',
            'title': 'Issue 1',
            'priority': 1,
            'number': 1,
            'identifier': 'P1-1',
            'status': 'open',
            'space': 's1',
          },
        ],
      );

      final issues = await container.read(issuesProvider('s1').future);
      expect(issues.length, 1);
      expect(issues[0].title, 'Issue 1');
      expect(issues[0].space, 's1');
    });

    test('issuesProvider refreshes when dataVersion changes', () async {
      final container = createContainer(
        overrides: [
          restClientProvider.overrideWithValue(mockRestClient),
        ],
      );

      int callCount = 0;
      when(() => mockRestClient.findAll(
            'tracker:class:Issue',
            query: {'space': 's1'},
            options: {'sort': {'modifiedOn': -1}, 'limit': 50},
          )).thenAnswer((_) async {
        callCount++;
        return [
          {
            '_id': 'i$callCount',
            '_class': 'tracker:class:Issue',
            'title': 'Issue $callCount',
            'priority': 1,
            'number': callCount,
            'identifier': 'P1-$callCount',
            'status': 'open',
            'space': 's1',
          },
        ];
      });

      // First fetch
      var issues = await container.read(issuesProvider('s1').future);
      expect(issues[0].title, 'Issue 1');
      expect(callCount, 1);

      // Bump data version
      container.read(dataVersionProvider.notifier).state++;

      // Next fetch should trigger refresh because of ref.watch(dataVersionProvider)
      issues = await container.read(issuesProvider('s1').future);
      expect(issues[0].title, 'Issue 2');
      expect(callCount, 2);
    });
  });
}
