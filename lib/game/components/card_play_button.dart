import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/state_machine/event.dart';

class CardPlayButton extends PositionComponent
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
        ?.handle(const Event(GameEvent.playCard));
  }

  @override
  void render(Canvas canvas) {
    if (_visible) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCircle(center: (size / 2).toOffset(), radius: size.x / 2),
          const Radius.circular(24),
        ),
        _paint,
      );
    }
  }
}
