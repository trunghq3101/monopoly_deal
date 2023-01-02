import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../routes/game.dart';
import '../utils.dart';

void main() {
  group('on createRoom event', () {
    HttpServer server;

    test(
      'should emit roomInfo event',
      () async {
        server = await serve(
          (context) => onRequest(
            context
                .provide<UuidOptions>(
                  () => testUuidOptions,
                )
                .provide(() => testCommandGenerator),
          ),
          InternetAddress.anyIPv4,
          0,
        );
        final socket = WebSocket(Uri.parse('ws://localhost:${server.port}'));
        await expectLater(socket.messages, emits(anything));

        socket.send(
          WsDto(PacketType.createRoom, CreateRoomPacket(testSid)).encode(),
        );

        await expectLater(
          socket.messages,
          emits(PacketMatcher(isA<RoomInfoPacket>())),
        );

        socket.close();
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
  });
}
