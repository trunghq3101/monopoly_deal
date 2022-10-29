import 'package:flame/components.dart';

class Hand extends PositionComponent {
  Hand() : super(anchor: Anchor.bottomCenter);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, size.y);
    this.size = size.clone()..clamp(Vector2.zero(), Vector2(800, 600));
  }
}
