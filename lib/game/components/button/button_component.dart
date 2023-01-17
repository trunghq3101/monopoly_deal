import 'dart:ui';

import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';

class ButtonComponent extends PositionComponent {
  ButtonComponent({this.text = "", TextAlign textAlign = TextAlign.right}) {
    size = MainGame.gameMap.buttonSize;
    final builder = ParagraphBuilder(ParagraphStyle(
      textAlign: textAlign,
      fontSize: 180,
    ))
      ..pushStyle(TextStyle(color: const Color(0xFF000000)))
      ..addText(text);
    _paragraph = builder.build()..layout(ParagraphConstraints(width: size.x));
    offsetX = textAlign == TextAlign.right
        ? -size.x * 0.1
        : textAlign == TextAlign.left
            ? size.x * 0.1
            : 0;
  }

  final String text;
  final _paint = Paint()
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.fill;
  late final Paragraph _paragraph;
  late double offsetX;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
    canvas.drawParagraph(
        _paragraph, Vector2(offsetX, size.y * 0.25).toOffset());
  }
}
