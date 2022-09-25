import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/game_model.dart';
import 'package:monopoly_deal/models/player_model.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';

import 'utils.dart';

class TestDriver {
  TestDriver({required this.tester, required this.gameRepository});

  final WidgetTester tester;
  final GameRepository gameRepository;
  GameModel gameMachine = GameModel(moves: [], players: [], step: Steps.idle);
  PlayerModel machinePlayer = PlayerModel(hand: []);

  Future<void> startGame() async {
    await tester.tap(find.text('Join'));
    // game.addPlayer() called
    await tester.pumpAndSettle();
    gameMachine = await gameMachine.addPlayer(machinePlayer, gameRepository);
    await flushTasks();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
  }
}
