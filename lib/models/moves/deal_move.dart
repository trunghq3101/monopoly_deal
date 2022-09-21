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
    for (var player in players) {
      for (var i = 0; i < 5; i++) {
        final card = deck.draw();
        player.add(card);
      }
    }
  }
}
