import 'package:flame/components.dart';

class Hand extends PositionComponent {
  Hand({super.position, super.size}) : super(anchor: Anchor.center);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    position = size / 2;
  }
}
