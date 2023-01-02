import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../routes/game.dart';
import '../utils.dart';

void main() {
  group('on connect', () {
    HttpServer server;

    test('should emit connected event', () async {
      server = await serve(
        (context) => onRequest(
          context.provide<UuidOptions>(
            () => testUuidOptions,
          ),
        ),
        InternetAddress.anyIPv4,
        0,
      );
      final socket = WebSocket(Uri.parse('ws://localhost:${server.port}'));

      await expectLater(
        socket.messages,
        emits(PacketMatcher(ConnectedPacket(testSid))),
      );

      socket.close();
    });
  });
}
