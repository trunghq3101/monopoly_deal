import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';

import '../test/utils.dart';

void main() {
  group('Start game', () {
    testWidgets('Users can be notified when game started', (tester) async {
      final user1 = RoomGateway();
      final user2 = RoomGateway();
      await testDelay();
      await user1.createRoom();
      await testDelay();
      await tester.pumpFrames(
        RoomModel(
          notifier: user1,
          child: MaterialApp(
            routes: {
              '/': (_) => const WaitingRoom(),
              '/game': (_) => GameWidget(game: MainGame2()),
            },
          ),
        ),
        const Duration(seconds: 1),
      );
      await user2.joinRoom(user1.roomId!);
      await testDelay();
      await user2.startGame();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(GameWidget<MainGame2>), findsOneWidget);
    });
  });
}
