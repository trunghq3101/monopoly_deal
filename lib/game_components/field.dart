import 'dart:ui';

import 'package:flame/components.dart';
import 'package:monopoly_deal/game_components/card.dart';

class Field extends PositionComponent {
  Field({super.position})
      : super(
          size: Vector2(Card.kCardWidth * 3, Card.kCardHeight * 4),
          anchor: Anchor.center,
        );

  final _paint = Paint()
    ..color = const Color.fromARGB(255, 246, 232, 46)
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }
}
