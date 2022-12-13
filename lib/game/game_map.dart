import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';

class GameMap {
  final Vector2 deckCenter;
  final double deckSpacing;
  final Vector2 cardSize;
  final List<Vector2> playerPositions;
  final Vector2 intialGameVisibleSize;
  final Vector2 overviewGameVisibleSize;
  late final _ratio = deckSpacing / cardSize.distanceTo(Vector2.zero());

  GameMap({
    Vector2? deckCenter,
    this.deckSpacing = 10,
    Vector2? cardSize,
    this.playerPositions = const [],
    Vector2? intialGameVisibleSize,
    Vector2? overviewGameVisibleSize,
  })  : deckCenter = deckCenter ?? Vector2.zero(),
        cardSize = cardSize ?? Vector2(300, 440),
        intialGameVisibleSize = intialGameVisibleSize ?? Vector2(600, 600),
        overviewGameVisibleSize =
            overviewGameVisibleSize ?? Vector2(2000, 3000);

  Vector2 inDeckPosition(int index) {
    return deckCenter -
        (cardSize * _ratio) * (index - (MainGame2.cardTotalAmount - 1) * 0.5);
  }

  bool isMyPosition(Vector2 position) {
    return position == playerPositions[0];
  }
}
