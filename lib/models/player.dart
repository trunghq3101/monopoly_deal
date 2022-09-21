import 'card.dart';

class Player {
  Player({List<Card>? hand}) : hand = List.from(hand ?? []);

  late List<Card> hand;

  void add(card) {
    hand.add(card);
  }

  void drop(Card card) {
    hand.remove(card);
  }
}
