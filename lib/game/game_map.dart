import 'package:flame/components.dart';

class GameMap {
  final Vector2 deckBottomRight;
  final double deckSpacing;
  final Vector2 cardSize;
  final List<Vector2> playerPositions;

  GameMap({
    Vector2? deckBottomRight,
    this.deckSpacing = 10,
    Vector2? cardSize,
    this.playerPositions = const [],
  })  : deckBottomRight = deckBottomRight ?? Vector2.zero(),
        cardSize = cardSize ?? Vector2(300, 440);

  Vector2 inDeckPosition(int index) {
    final ratio = deckSpacing / cardSize.distanceTo(Vector2.zero());
    return deckBottomRight - (cardSize * ratio) * index.toDouble();
  }
}
