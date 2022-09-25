import 'dart:collection';

import 'package:monopoly_deal/models/moves/move_model.dart';
import 'package:monopoly_deal/models/player_model.dart';

import '../models/card_model.dart';
import '../models/game_model.dart';
import '../models/player.dart';
import '../repositories/game_repository.dart';

class TestGameRepository extends GameRepository {
  GameModel _gameModel = GameModel(players: [], step: Steps.idle, moves: []);

  @override
  GameModel get gameModel => _gameModel;

  @override
  Future<UnmodifiableListView<Player>> fetchPlayers() async {
    return UnmodifiableListView([]);
  }

  @override
  Future<void> addPlayer(PlayerModel player) async {
    final newPlayers = UnmodifiableListView([...gameModel.players, player]);
    _gameModel = gameModel.copyWith(
      players: newPlayers,
    );
    if (gameModel.gameState == GameState.ready) {
      final player0initialHand = [
        CardModel(name: '14'),
        CardModel(name: '12'),
        CardModel(name: '10'),
        CardModel(name: '8'),
        CardModel(name: '6')
      ];
      _gameModel = gameModel.copyWith(
        players: [
          gameModel.players[0].copyWith(hand: player0initialHand),
          gameModel.players[1]
        ],
        moves: [
          ...gameModel.moves,
          MoveModel.dealMove(player: player, cards: player0initialHand)
        ],
      );
    }
  }

  @override
  Future<Player?> fetchTurnOwner() async {
    return null;
  }
}
