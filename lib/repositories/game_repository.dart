import '../models/player.dart';

class GameRepository {
  Future<List<Player>> fetchPlayers() async {
    return [];
  }

  Future<void> addPlayer(Player player) async {}

  Future<Player?> fetchTurnOwner() async {
    return null;
  }
}
