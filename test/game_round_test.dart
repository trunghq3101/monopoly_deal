import 'package:flutter_test/flutter_test.dart';

class Player {}

class GameRound {
  final List<Player> _players = [];

  void start() {
    assert(_players.length > 1);
  }

  void addPlayer(Player player) {
    _players.add(player);
  }
}

void main() {
  group('GameRound test', () {
    test('Must have at least 2 players to start', () {
      final gameRound = GameRound();
      expect(() => gameRound.start(), throwsAssertionError);
      gameRound.addPlayer(Player());
      expect(() => gameRound.start(), throwsAssertionError);
      gameRound.addPlayer(Player());
      gameRound.start();
    });
  });
}
