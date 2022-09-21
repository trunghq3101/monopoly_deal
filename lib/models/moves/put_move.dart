import '../card.dart';
import 'move.dart';

class PutMove extends GameMove {
  PutMove({
    required super.player,
    required this.card,
  });

  final Card card;

  @override
  void move() {
    player.drop(card);
  }
}
