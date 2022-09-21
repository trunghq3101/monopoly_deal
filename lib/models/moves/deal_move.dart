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
    assert(deck.initial.length >= players.length * 5);
    var playerIndex = 0;
    for (var i = 0; i < players.length * 5; i++) {
      final card = deck.draw();
      players[playerIndex].add(card);
      playerIndex = (playerIndex + 1) % players.length;
    }
  }
}
