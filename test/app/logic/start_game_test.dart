import 'package:flutter_test/flutter_test.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';

import '../../utils.dart';

void main() {
  group('Start game', () {
    test('Users can be notified when game started', () async {
      final user1 = RoomGateway();
      final user2 = RoomGateway();
      await testDelay();
      user1.createRoom();
      await testDelay();
      user2.joinRoom(user1.roomId!);
      await testDelay();
      user1.startGame();
      expectLater(user1.gameEvents,
          emits(WsDto(PacketType.gameStarted, EmptyPacket())));
      expectLater(user2.gameEvents,
          emits(WsDto(PacketType.gameStarted, EmptyPacket())));
    });
  });
}
