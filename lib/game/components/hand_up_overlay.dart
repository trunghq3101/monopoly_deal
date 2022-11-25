import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';

class HandUpOverlay extends PositionComponent
    with TapCallbacks, HasGameRef<BaseGame> {
  bool _enabled = false;

  void enable() => _enabled = true;
  void disable() => _enabled = false;

  @override
  void onTapDown(TapDownEvent event) {
    if (_enabled) {
      gameRef.children
          .query<Player>()
          .firstOrNull
          ?.handle(event, EventSender.handUpOverlay);
    } else {
      event.continuePropagation = true;
    }
  }
}
