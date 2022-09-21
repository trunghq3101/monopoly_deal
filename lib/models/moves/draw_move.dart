import 'package:monopoly_deal/models/card.dart';

import 'move.dart';

class DrawMove extends GameMove {
  DrawMove({
    required super.player,
    required this.deck,
    required this.amount,
  });

  final CardDeck deck;
  final int amount;

  @override
  void move() {
    assert(deck.remaining.length >= amount);
    for (var i = 0; i < amount; i++) {
      final card = deck.draw();
      player.hand.add(card);
    }
  }
}
