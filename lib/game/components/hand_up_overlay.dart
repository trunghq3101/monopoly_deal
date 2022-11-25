import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';

class HandUpOverlay extends PositionComponent
    with TapCallbacks, HasGameRef<BaseGame> {
  @override
  void onTapDown(TapDownEvent event) {
    gameRef.children
        .query<Player>()
        .firstOrNull
        ?.handle(event, EventSender.handUpOverlay);
  }
}
