import 'package:monopoly_deal/models/card.dart';

import '../repositories/game_repository.dart';
import 'player.dart';

enum Steps { idle, draw, play, drop, end }

enum GameState { waiting, ready }

class GameRound {
  var started = false;
  var _playerJoined = false;
  Player? turnOwner;
  final List<Player> players = [];
  late final GameRepository _gameRepository;
  late CardDeck cardDeck;

  Steps step = Steps.idle;

  GameRound({GameRepository? repository})
      : _gameRepository = repository ?? GameRepository();

  void start() {
    assert(players.length > 1);
    started = true;
    cardDeck = CardDeck(game: this);
  }

  Future<void> addPlayer(Player player) async {
    if (_playerJoined) throw Exception('Already joined this game');
    await _gameRepository.addPlayer(player);
    _playerJoined = true;
  }

  void turnTo({required Player player}) {
    turnOwner = player;
  }

  Future<GameState> fetchState() async {
    final players = await _gameRepository.fetchPlayers();
    if (players.length > 1) return GameState.ready;
    return GameState.waiting;
  }

  fetchTurnOwner() {}

  nextStep() {}

  fetchLastMove() {}
}
