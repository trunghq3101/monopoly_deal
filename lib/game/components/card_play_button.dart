import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/state_machine/event.dart';

class CardPlayButton extends PositionComponent
    with TapCallbacks, HasGameRef<BaseGame> {
  final _paint = Paint()..color = const Color.fromARGB(255, 113, 253, 253);
  late final _path = Path()
    ..moveTo(0, size.y)
    ..lineTo(size.x, size.y)
    ..lineTo(size.x, 0)
    ..lineTo(size.x * 0.1, 0)
    ..lineTo(size.x * 0.1, size.y * 0.4)
    ..lineTo(0, size.y * 0.5)
    ..lineTo(size.x * 0.1, size.y * 0.6)
    ..lineTo(size.x * 0.1, size.y);
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
        ?.handle(const Event(GameEvent.playCard));
  }

  @override
  void render(Canvas canvas) {
    if (_visible) {
      final builder = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 100,
      ))
        ..pushStyle(TextStyle(color: const Color(0xFF000000)))
        ..addText('Play');
      final p = builder.build()..layout(ParagraphConstraints(width: size.x));
      canvas.drawPath(_path, _paint);
      canvas.drawParagraph(p, Vector2(size.x * 0.05, size.y * 0.2).toOffset());
    }
  }
}
