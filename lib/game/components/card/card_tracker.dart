import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';

class CardTracker extends Component
    with HasGameReference<FlameGame>, HasWorldRef {
  List<HasCardId> cardsInDeckFromTop() {
    final allCards = world.children.query<Card>();
    final cardsInDeck =
        allCards.where((c) => c.state == CardState.inDeck).toList();
    cardsInDeck.sort((a, b) => b.priority.compareTo(a.priority));
    return cardsInDeck;
  }
}
