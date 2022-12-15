import 'dart:ui';

import 'package:flame/components.dart';

class ButtonComponent extends PositionComponent {
  ButtonComponent({this.text = ""}) {
    size = Vector2(380, 160);
    final builder = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.right,
      fontSize: 80,
    ))
      ..pushStyle(TextStyle(color: const Color(0xFF000000)))
      ..addText(text);
    _paragraph = builder.build()..layout(ParagraphConstraints(width: size.x));
  }

  final String text;
  final _paint = Paint()
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.fill;
  late final Paragraph _paragraph;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
    canvas.drawParagraph(
        _paragraph, Vector2(-size.x * 0.1, size.y * 0.2).toOffset());
  }
}
