import 'player.dart';

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
