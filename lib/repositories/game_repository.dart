import 'package:monopoly_deal/models/game_model.dart';
import 'package:monopoly_deal/models/player_model.dart';

import '../models/player.dart';

abstract class GameRepository {
  GameModel get gameModel;

  Future<List<Player>> fetchPlayers();

  Future<void> addPlayer(PlayerModel player);

  Future<Player?> fetchTurnOwner();
}
