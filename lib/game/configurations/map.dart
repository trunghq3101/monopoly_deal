import 'package:flame/components.dart';

enum GameSize {
  cardOnTable(300, 440),
  cardInHand(750, 1100),
  visibleInitial(600, 600),
  visibleAfterDealing(2000, 3000);

  final double x;
  final double y;

  const GameSize(this.x, this.y);

  Vector2 get size => Vector2(x, y);
}

enum GamePosition {
  deck(0, 0),
  dealTargetMe(0, 1000),
  dealTarget1(0, -1000),
  previewCard(0, -500);

  final double x;
  final double y;

  const GamePosition(this.x, this.y);

  Vector2 get position => Vector2(x, y);
}
