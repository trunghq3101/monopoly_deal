import 'package:monopoly_deal/models/card.dart';
import 'package:monopoly_deal/models/moves/move.dart';

import '../repositories/game_repository.dart';
import 'player.dart';

enum Steps { idle, draw, play, drop }

enum GameState { waiting, ready }

class GameRound {
  late final GameRepository _gameRepository;

  var _playerJoined = false;

  Player? turnOwner;
  List<Player> players = [];
  GameState gameState = GameState.waiting;
  Steps step = Steps.idle;
  List<GameMove> moves = [];

  GameRound({GameRepository? repository})
      : _gameRepository = repository ?? GameRepository();

  Future<void> addPlayer(Player player) async {
    if (_playerJoined) throw Exception('Already joined this game');
    await _gameRepository.addPlayer(player);
    _playerJoined = true;
  }

  Future<void> syncUp() async {
    players = await _gameRepository.fetchPlayers();
    if (players.length > 1) {
      turnOwner = await _gameRepository.fetchTurnOwner();
      gameState = GameState.ready;
      return;
    }
    gameState = GameState.waiting;
  }

  Steps nextStep() {
    step = Steps.values[(step.index + 1) % Steps.values.length];
    return step;
  }
}
