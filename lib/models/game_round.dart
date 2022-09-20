import 'package:monopoly_deal/models/card.dart';

import 'player.dart';

class GameRound {
  var started = false;
  Player? turnOwner;
  final List<Player> players = [];
  late CardDeck cardDeck;

  GameRound();

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
}
