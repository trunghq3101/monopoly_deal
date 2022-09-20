import 'package:monopoly_deal/models/game_round.dart';

class Player {
  Player({required this.game});

  final GameRound game;

  void draw() {
    if (game.turnOwner != this) throw Exception('It is not your turn.');
    game.cardDeck.draw();
  }
}
