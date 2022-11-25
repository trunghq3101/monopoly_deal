import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/state_machine/event.dart';

class PickUpRegion extends PositionComponent
    with TapCallbacks, HoverCallbacks, HasGameRef<BaseGame> {
  @override
  void onTapDown(TapDownEvent event) {
    gameRef.children.query<Player>().firstOrNull?.handle(Event(
          GameEvent.tapPickUpRegion,
          gameRef.world
              .componentsAtPoint(absolutePosition)
              .whereType<CardBack>()
              .toList(),
        ));
    removeFromParent();
  }
}
