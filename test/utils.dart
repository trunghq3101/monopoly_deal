import 'package:monopoly_deal/models/game_round.dart';
import 'package:monopoly_deal/models/player.dart';

class TestUtils {
  static GameRound getGame({
    bool started = false,
  }) {
    final game = GameRound();
    if (!started) return game;
    game.addPlayer(Player(game: game));
    game.addPlayer(Player(game: game));
    game.start();
    return game;
  }
}
