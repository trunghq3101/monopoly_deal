import '../card.dart';
import '../player.dart';
import 'move.dart';

class DealMove extends GameMove {
  DealMove({
    required super.player,
    required this.deck,
    required this.players,
  });

  final CardDeck deck;
  final List<Player> players;

  @override
  void move() {
    deck.currentLength -= 10;
    for (var player in players) {
      player.hand.addAll(List.generate(5, (index) => Card('$index')));
    }
  }
}
