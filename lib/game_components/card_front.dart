import 'dart:ui';

import 'package:flame/components.dart';

class CardFront extends PositionComponent with ParentIsA<PositionComponent> {
  CardFront({required this.id, super.position, super.size})
      : super(anchor: Anchor.center);

  final int id;

  @override
  operator ==(other) => other is CardFront && other.id == id;

  @override
  int get hashCode => id;

  @override
  void render(Canvas canvas) {
    final size = this.size.toSize();
    const sw = 40.0;
    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw;
    paintStroke.color = const Color.fromARGB(255, 255, 146, 38);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw / 2, sw / 2, size.width - sw, size.height - sw),
        Radius.circular(size.width * 0.07),
      ),
      paintStroke,
    );

    Paint paintFill = Paint()..style = PaintingStyle.fill;
    paintFill.color = const Color.fromARGB(255, 255, 248, 200);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw / 2, sw / 2, size.width - sw, size.height - sw),
        Radius.circular(size.width * 0.07),
      ),
      paintFill,
    );
    final b = ParagraphBuilder(
        ParagraphStyle(fontSize: 40, textAlign: TextAlign.center))
      ..pushStyle(TextStyle(color: const Color(0xFF000000)))
      ..addText('$id');
    final p = b.build();
    p.layout(ParagraphConstraints(width: size.width));
    canvas.drawParagraph(p, Offset(0, size.height / 2));
  }
}
