import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../routes/_middleware.dart';
import '../routes/game.dart';
import 'utils.dart';

void main() {
  group(
    'Start game',
    () {
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

      test('User 1 can start game', () async {
        final user1 = WebSocket(Uri.parse('ws://localhost:${server.port}'));
        await testDelay();
        user1.send('0,');
        await testDelay();
        user1.send('7,');

        unawaited(expectLater(user1.messages, emitsThrough('8,')));
      });

      test('User 2 receives notification about game started', () async {
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

        unawaited(expectLater(user2.messages, emitsThrough('8,')));
      });

      test('Each user receives starter cards', () async {
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
        final deck = requestContext.read<RoomsManager>().findById(roomId).deck;

        user1.send('9,0');
        unawaited(
          expectLater(user1.messages, emitsThrough('10,${deck.at(0)}')),
        );

        user2.send('9,1');
        unawaited(
          expectLater(user2.messages, emitsThrough('10,${deck.at(1)}')),
        );
      });
    },
    timeout: Timeout.parse('2s'),
  );
}
