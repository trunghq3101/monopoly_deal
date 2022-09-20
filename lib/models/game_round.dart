import 'package:monopoly_deal/models/card.dart';

import '../repositories/game_repository.dart';
import 'player.dart';

enum Steps { idle, draw, play, drop, end }

class GameRound {
  var started = false;
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

  void addPlayer(Player player) {
    players.add(player);
  }

  void turnTo({required Player player}) {
    turnOwner = player;
  }

  fetchState() {}

  fetchTurnOwner() {}

  nextStep() {}

  fetchLastMove() {}
}
