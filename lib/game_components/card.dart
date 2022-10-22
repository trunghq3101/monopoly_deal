import 'dart:ui';

import 'package:flame/components.dart';

class Card extends PositionComponent {
  Card({
    required this.id,
    required super.position,
    required super.priority,
    Vector2? size,
  }) : super(size: size ?? kCardSize, anchor: Anchor.center);

  static const kCardWidth = 1120.0;
  static const kCardHeight = 1584.0;
  static final kCardSize = Vector2(kCardWidth, kCardHeight);

  final int id;

  @override
  operator ==(other) => other is Card && other.id == id;

  @override
  int get hashCode => id;

  @override
  String toString() => 'Card $id';

  @override
  void render(Canvas canvas) {
    final size = this.size.toSize();
    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 120;
    paintStroke.color = const Color.fromARGB(255, 255, 255, 255);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.width * 0.07),
      ),
      paintStroke,
    );

    Paint paintFill = Paint()..style = PaintingStyle.fill;
    paintFill.color = const Color(0xffC4C4C4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.width * 0.07),
      ),
      paintFill,
    );
    final b = ParagraphBuilder(ParagraphStyle(fontSize: 120))..addText('$id');
    final p = b.build();
    p.layout(const ParagraphConstraints(width: 800));
    canvas.drawParagraph(p, this.size.toOffset() / 2);
  }
}
