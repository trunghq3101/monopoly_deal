import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/state_machine/event.dart';

class EndTurnButton extends PositionComponent
    with TapCallbacks, HasGameRef<BaseGame> {
  final _paint = Paint()..color = const Color.fromARGB(255, 113, 253, 253);
  bool _visible = false;

  void show() => _visible = true;
  void hide() => _visible = false;

  @override
  void onTapDown(TapDownEvent event) {
    if (!_visible) {
      event.continuePropagation = true;
      return;
    }
    gameRef.children
        .query<Player>()
        .firstOrNull
        ?.handle(const Event(GameEvent.tapEndTurnButton));
  }

  @override
  void render(Canvas canvas) {
    if (_visible) {
      final builder = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 100,
      ))
        ..pushStyle(TextStyle(color: const Color(0xFF000000)))
        ..addText('End turn');
      final p = builder.build()..layout(ParagraphConstraints(width: size.x));
      canvas.drawRect(
          Rect.fromCenter(
              center: (size * 0.5).toOffset(), width: width, height: height),
          _paint);
      canvas.drawParagraph(p, Vector2(0, size.y * 0.2).toOffset());
    }
  }
}
