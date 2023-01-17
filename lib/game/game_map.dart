import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';

class GameMap {
  final Vector2 deckCenter;
  final double deckSpacing;
  final Vector2 cardSize;
  final Vector2 cardSizeInHand;
  final List<Vector2> playerPositions;
  final Vector2 intialGameVisibleSize;
  final Vector2 overviewGameVisibleSize;
  late final Vector2 overviewGameVisibleSize2 = Vector2(3000, 4500);
  final Vector2 buttonSize = Vector2(855, 360);
  final int myIndex;
  late final _ratio = deckSpacing / cardSize.distanceTo(Vector2.zero());
  final Map<int, Vector2> _indexToPosition = {};

  GameMap({
    Vector2? deckCenter,
    this.deckSpacing = 10,
    Vector2? cardSize,
    this.playerPositions = const [],
    Vector2? intialGameVisibleSize,
    Vector2? overviewGameVisibleSize,
    this.myIndex = 0,
  })  : deckCenter = deckCenter ?? Vector2.zero(),
        cardSize = cardSize ?? Vector2(300, 440),
        cardSizeInHand = Vector2(750, 1100) * 1.8,
        intialGameVisibleSize = intialGameVisibleSize ?? Vector2(600, 600),
        overviewGameVisibleSize =
            overviewGameVisibleSize ?? Vector2(4000, 8000) {
    final playerAmount = playerPositions.length;
    for (var i = 0; i < playerAmount; i++) {
      _indexToPosition[(myIndex + i) % playerAmount] = playerPositions[i];
    }
  }

  Vector2 inDeckPosition(int index) {
    return deckCenter -
        (cardSize * _ratio) * (index - (MainGame.cardTotalAmount - 1) * 0.5);
  }

  bool isMyPosition(Vector2 position) {
    return position == positionForPlayerIndex(myIndex);
  }

  Vector2 positionForPlayerIndex(int index) {
    final position = _indexToPosition[index];
    if (position == null) {
      throw StateError('Position for player index $index not available');
    }
    return position;
  }
}
