import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/rendering.dart';

class GlowingDecorator extends Decorator {
  GlowingDecorator({
    required this.component,
    required this.spread,
    required this.radius,
    required this.color,
    required this.sigma,
  });
  final PositionComponent component;
  final double spread;
  final Radius radius;
  final Color color;
  final double sigma;

  late final _paint = Paint()
    ..color = color
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);

  @override
  void apply(void Function(Canvas) draw, Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: (component.size / 2).toOffset(),
          width: component.width + spread,
          height: component.height + spread,
        ),
        radius,
      ),
      _paint,
    );
    draw(canvas);
  }
}
