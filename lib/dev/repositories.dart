import 'dart:collection';

import '../models/player.dart';
import '../repositories/game_repository.dart';

class TestGameRepository extends GameRepository {
  UnmodifiableListView<Player> _players = UnmodifiableListView([]);

  @override
  Future<UnmodifiableListView<Player>> fetchPlayers() async {
    return _players;
  }

  @override
  Future<void> addPlayer(Player player) async {
    _players = UnmodifiableListView([..._players, player]);
  }

  @override
  Future<Player?> fetchTurnOwner() async {
    return _players.first;
  }
}
