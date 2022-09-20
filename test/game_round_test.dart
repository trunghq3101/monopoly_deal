import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/game_round.dart';
import 'package:monopoly_deal/models/player.dart';

void main() {
  group('GameRound test', () {
    test('Must have at least 2 players to start', () {
      final gameRound = GameRound();
      expect(gameRound.started, false);
      expect(() => gameRound.start(), throwsAssertionError);
      gameRound.addPlayer(Player(game: gameRound));
      expect(() => gameRound.start(), throwsAssertionError);
      gameRound.addPlayer(Player(game: gameRound));
      gameRound.start();
      expect(gameRound.started, true);
    });
  });
}
