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
  group('Connection', () {
    late HttpServer server;
    String uuidGenerator() => 'user1';

    setUp(() async {
      server = await serve(
        const Pipeline().addMiddleware(middleware).addHandler((context) {
          return onRequest(
            context.provide<RandomProvider>(() {
              return RandomProvider(
                uuidGenerator: uuidGenerator,
              );
            }),
          );
        }),
        InternetAddress.anyIPv4,
        0,
      );
    });

    test('User receives sid when connected', () async {
      final user1 = WebSocket(Uri.parse('ws://localhost:${server.port}'));
      await testDelay();
      unawaited(expectLater(user1.messages, emits('12,user1')));
      user1.send('13,');
    });
  });
}
