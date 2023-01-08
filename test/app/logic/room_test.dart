import 'package:monopoly_deal/app/app.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group(
    'Room',
    () {
      late RoomGateway gateway;

      test('User 1 can create a room and receive a room code', () async {
        gateway = RoomGateway();
        await gateway.createRoom();
        await kDelay();
        expect(gateway.roomId, isA<String>());
      });

      test('User 1 receives error when creating room twice', () async {
        final wsManager = WsManager();
        gateway = RoomGateway(wsManager: wsManager);
        await gateway.createRoom();
        await kDelay();
        await gateway.createRoom();
        final conn = await wsManager.connection();
        await expectLater(
          conn.messages,
          emitsThrough('6,alreadyInRoom'),
        );
      });

      test('User 1 sees themselves in the room', () async {
        gateway = RoomGateway();
        await gateway.createRoom();
        await kDelay();
        expect(gateway.members?.length, 1);
      });

      test(
          'User 2 can join the room and see themselves in the room with user 1',
          () async {
        final roomId = await _createRoom();
        gateway = RoomGateway();
        await gateway.joinRoom(roomId);
        await kDelay();
        expect(gateway.members?.length, 2);
      });
    },
    timeout: Timeout.parse('2s'),
  );
}

Future<String> _createRoom() async {
  final gateway = RoomGateway();
  await gateway.createRoom();
  await kDelay();
  return gateway.roomId!;
}
