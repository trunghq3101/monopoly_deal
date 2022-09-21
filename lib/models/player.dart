import 'card.dart';

class Player {
  List<Card> hand = [];

  Player();

  void add(card) {
    hand.add(card);
  }
}
