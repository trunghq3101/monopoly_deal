import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/dev/repositories.dart';
import 'package:monopoly_deal/models/game_model.dart';
import 'package:monopoly_deal/models/player_model.dart';
import 'package:monopoly_deal/pages/home_page.dart';

void main() {
  testWidgets('Start game', (tester) async {
    final gameRepository = TestGameRepository();
    var gameMachine = GameModel(moves: [], players: [], step: Steps.idle);
    var machinePlayer = PlayerModel(hand: []);
    await tester.pumpWidget(MaterialApp(
      home: HomePage(gameRepository: gameRepository),
    ));
    await tester.tap(find.text('Join'));
    // game.addPlayer() called
    await tester.pumpAndSettle();
    gameMachine = await gameMachine.addPlayer(machinePlayer, gameRepository);
    await Future.delayed(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
  });
}
