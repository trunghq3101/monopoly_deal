import 'package:flutter_test/flutter_test.dart';

class Player {}

class GameRound {
  var started = false;
  final List<Player> _players = [];

  void start() {
    assert(_players.length > 1);
    started = true;
  }

  void addPlayer(Player player) {
    _players.add(player);
  }
}

void main() {
  group('GameRound test', () {
    test('Must have at least 2 players to start', () {
      final gameRound = GameRound();
      expect(gameRound.started, false);
      expect(() => gameRound.start(), throwsAssertionError);
      gameRound.addPlayer(Player());
      expect(() => gameRound.start(), throwsAssertionError);
      gameRound.addPlayer(Player());
      gameRound.start();
      expect(gameRound.started, true);
    });
  });
}
