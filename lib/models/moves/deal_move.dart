import '../card.dart';
import 'move.dart';

class DealMove extends GameMove {
  DealMove({
    required super.player,
    required this.deck,
    required this.playerNumber,
  });

  final CardDeck deck;
  final int playerNumber;

  @override
  void move() {}
}
