import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';

class GameMap {
  final Vector2 deckCenter;
  final double deckSpacing;
  final Vector2 cardSize;
  final List<Vector2> playerPositions;

  GameMap({
    Vector2? deckCenter,
    this.deckSpacing = 10,
    Vector2? cardSize,
    this.playerPositions = const [],
  })  : deckCenter = deckCenter ?? Vector2.zero(),
        cardSize = cardSize ?? Vector2(300, 440);

  late final _ratio = deckSpacing / cardSize.distanceTo(Vector2.zero());

  Vector2 inDeckPosition(int index) {
    return deckCenter -
        (cardSize * _ratio) * (index - (MainGame2.cardTotalAmount - 1) * 0.5);
  }
}
