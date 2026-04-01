import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huly_mobile/core/api/rest_client.dart';
import 'package:huly_mobile/features/auth/auth_provider.dart';
import 'package:huly_mobile/features/chat/chat_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockRestClient extends Mock implements HulyRestClient {}

void main() {
  group('ChatProvider', () {
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

    test('channelsProvider fetches channels and DMs and sorts them', () async {
      final container = createContainer(
        overrides: [
          restClientProvider.overrideWithValue(mockRestClient),
        ],
      );

      when(() => mockRestClient.findAll('chunter:class:Channel')).thenAnswer(
        (_) async => [
          {
            '_id': 'c1',
            '_class': 'chunter:class:Channel',
            'name': 'Channel 1',
            'modifiedOn': 100,
          },
        ],
      );

      when(() => mockRestClient.findAll('chunter:class:DirectMessage')).thenAnswer(
        (_) async => [
          {
            '_id': 'dm1',
            '_class': 'chunter:class:DirectMessage',
            'name': 'DM 1',
            'modifiedOn': 200,
          },
        ],
      );

      final channels = await container.read(channelsProvider.future);
      expect(channels.length, 2);
      // Sorted by modifiedOn descending
      expect(channels[0].id, 'dm1');
      expect(channels[1].id, 'c1');
    });

    test('channelMessagesProvider fetches messages for channel', () async {
      final container = createContainer(
        overrides: [
          restClientProvider.overrideWithValue(mockRestClient),
        ],
      );

      when(() => mockRestClient.findAll(
            'chunter:class:ChatMessage',
            query: {'attachedTo': 'c1'},
            options: {'sort': {'createdOn': 1}, 'limit': 200},
          )).thenAnswer(
        (_) async => [
          {
            '_id': 'm1',
            '_class': 'chunter:class:ChatMessage',
            'attachedTo': 'c1',
            'message': 'Hello',
            'createdOn': 1000,
          },
        ],
      );

      final messages = await container.read(channelMessagesProvider('c1').future);
      expect(messages.length, 1);
      expect(messages[0].message, 'Hello');
    });
  });
}
