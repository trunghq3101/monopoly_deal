import '../models/player.dart';
import '../repositories/game_repository.dart';

class TestGameRepository extends GameRepository {
  final List<Player> _players = [];

  @override
  Future<List<Player>> fetchPlayers() async {
    return _players;
  }

  @override
  Future<void> addPlayer(Player player) async {
    _players.add(player);
  }

  @override
  Future<Player?> fetchTurnOwner() async {
    return _players.first;
  }
}
