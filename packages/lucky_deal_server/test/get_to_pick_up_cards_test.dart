import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../routes/_middleware.dart';
import '../routes/game.dart';
import 'utils.dart';

void main() {
  group('Get to-pick-up cards', () {
    late HttpServer server;
    late RequestContext requestContext;

    setUp(() async {
      server = await serve(
        const Pipeline().addMiddleware(middleware).addHandler((context) {
          requestContext = context;
          return onRequest(context);
        }),
        InternetAddress.anyIPv4,
        0,
      );
    });

    test('Each user receives 5 cards when game started', () async {
      final user1 = WebSocket(Uri.parse('ws://localhost:${server.port}'));
      await testDelay();
      user1.send('0,');
      await testDelay();
      final roomId = requestContext.read<RoomsManager>().lastRoomId;
      final user2 = WebSocket(Uri.parse('ws://localhost:${server.port}'));
      await testDelay();
      user2.send('4,$roomId');
      await testDelay();
      user1.send('7,');
      await testDelay();

      user1.send('9,');
      user2.send('9,');

      await expectLater(user1.messages, emitsThrough(contains('10')));
      await expectLater(user2.messages, emitsThrough(contains('10')));
    });
  });
}
