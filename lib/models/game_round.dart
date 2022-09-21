import 'package:monopoly_deal/models/card.dart';

import '../repositories/game_repository.dart';
import 'player.dart';

enum Steps { idle, draw, play, drop }

enum GameState { waiting, ready }

class GameRound {
  var started = false;
  var _playerJoined = false;
  Player? turnOwner;
  List<Player> players = [];
  late final GameRepository _gameRepository;
  late CardDeck cardDeck;

  Steps step = Steps.idle;

  GameRound({GameRepository? repository})
      : _gameRepository = repository ?? GameRepository() {
    cardDeck = CardDeck(initial: []);
  }

  Future<void> addPlayer(Player player) async {
    if (_playerJoined) throw Exception('Already joined this game');
    await _gameRepository.addPlayer(player);
    _playerJoined = true;
  }

  Future<GameState> fetchState() async {
    players = await _gameRepository.fetchPlayers();
    if (players.length > 1) {
      turnOwner = await _gameRepository.fetchTurnOwner();
      return GameState.ready;
    }
    return GameState.waiting;
  }

  Steps nextStep() {
    step = Steps.values[(step.index + 1) % Steps.values.length];
    return step;
  }

  fetchLastMove() {}
}
