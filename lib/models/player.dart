import 'package:monopoly_deal/models/game_round.dart';

class Player {
  Player({required this.game});

  final GameRound game;

  void draw() {
    if (game.turnOwner != this) throw Exception('It is not your turn.');
    game.cardDeck.draw();
  }

  Steps nextStep() {
    game.step = Steps.values[((game.step.index + 1) % Steps.values.length)];
    return game.step;
  }
}
