import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class CardFront extends SpriteComponent {
  CardFront({
    required this.id,
    super.sprite,
    super.position,
    super.size,
    super.anchor = Anchor.center,
  });

  final int id;
  bool targeting = false;

  @override
  operator ==(other) => other is CardFront && other.id == id;

  @override
  int get hashCode => id;

  @override
  void render(Canvas canvas) {
    if (targeting) {
      final drawPosition = size / 2;
      final drawSize = size + Vector2.all(5);

      final delta = Anchor.center.toVector2()..multiply(drawSize);
      final drawRect = (drawPosition - delta).toPositionedRect(drawSize);

      canvas.drawRRect(
          RRect.fromRectAndRadius(drawRect, const Radius.circular(20)),
          BasicPalette.white.paint()
            ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 10));
    }

    super.render(canvas);
  }
}
