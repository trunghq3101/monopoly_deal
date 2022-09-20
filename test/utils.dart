import 'package:monopoly_deal/models/game_round.dart';
import 'package:monopoly_deal/models/player.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';

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
}
