import 'game_round.dart';

class Card {}

class CardDeck {
  CardDeck({
    GameRound? game,
    int fullLength = 110,
  })  : game = game ?? GameRound(),
        currentLength = fullLength;

  final GameRound game;
  late int currentLength;

  List<Card> draw() {
    assert(game.started);
    if (currentLength == 0) return [];
    currentLength -= 2;
    return [Card(), Card()];
  }
}
