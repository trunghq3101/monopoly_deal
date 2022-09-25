import 'dart:collection';

import 'package:monopoly_deal/models/moves/move_model.dart';
import 'package:monopoly_deal/models/player_model.dart';

import '../models/card_model.dart';
import '../models/game_model.dart';
import '../models/player.dart';
import '../repositories/game_repository.dart';

class TestGameRepository extends GameRepository {
  GameModel _gameModel = GameModel(players: [], step: Steps.idle, moves: []);
  final _cards = List.generate(15, (index) => CardModel(name: '$index'));

  @override
  GameModel get gameModel => _gameModel;

  @override
  Future<UnmodifiableListView<Player>> fetchPlayers() async {
    return UnmodifiableListView([]);
  }

  @override
  Future<void> addPlayer(PlayerModel player) async {
    _gameModel = gameModel.copyWith(
      players: [...gameModel.players, player],
    );
    if (gameModel.gameState == GameState.ready) {
      final player0initialHand = [
        _cards[14],
        _cards[12],
        _cards[10],
        _cards[8],
        _cards[6]
      ];
      final player1initialHand = [
        _cards[13],
        _cards[11],
        _cards[9],
        _cards[7],
        _cards[5]
      ];
      final updatedPlayers = [
        gameModel.players[0].copyWith(hand: player0initialHand),
        gameModel.players[1].copyWith(hand: player1initialHand)
      ];
      _gameModel = gameModel.copyWith(
        turnOwner: updatedPlayers[0],
        players: updatedPlayers,
        moves: [
          MoveModel.dealMove(
              player: gameModel.players[0], cards: player0initialHand),
          MoveModel.dealMove(
              player: gameModel.players[1], cards: player1initialHand)
        ],
      );
    }
  }

  @override
  Future<Player?> fetchTurnOwner() async {
    return null;
  }
}
