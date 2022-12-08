import 'package:flame/components.dart';
import 'package:flame/game.dart';

class GameMap extends Component {
  final Vector2 deckBottomRight;
  final double deckSpacing;
  final Vector2 cardSize;

  GameMap({
    Vector2? deckBottomRight,
    this.deckSpacing = 10,
    Vector2? cardSize,
  })  : deckBottomRight = deckBottomRight ?? Vector2.zero(),
        cardSize = cardSize ?? Vector2(300, 440);

  Vector2 inDeckPosition(int index) {
    final ratio = deckSpacing / cardSize.distanceTo(Vector2.zero());
    return deckBottomRight - (cardSize * ratio) * index.toDouble();
  }
}

mixin HasGameMapRef implements HasGameRef<FlameGame> {
  GameMap get gameMap => game.children.query<GameMap>().first;
}
