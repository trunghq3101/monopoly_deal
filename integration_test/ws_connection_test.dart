import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart';

void main() {
  group('WsConnection', () {
    late WsConnection connection;

    setUp(() {
      connection = WsConnection();
    });

    test('connect', () {
      expect(
        connection.stateStream,
        emitsInOrder([const Connecting(), const Connected()]),
      );
      expect(connection.messageStream, emits(isA<ConnectedPacket>()));
    });

    test('create room', () {
      connection.createRoom();

      expect(connection.messageStream, emitsThrough(isA<CreatedRoomPacket>()));
    });

    test('join room', () async {
      connection.createRoom();
      final completer = Completer<int>();
      connection.messageStream.listen((event) {
        if (event is CreatedRoomPacket) {
          completer.complete(event.roomId);
        }
      });
      final roomId = await completer.future;

      connection = WsConnection();
      connection.joinRoom(roomId);

      expect(connection.messageStream, emitsThrough(isA<JoinedRoomPacket>()));
    });
  });
}
