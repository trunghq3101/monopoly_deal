import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';

class PickUpRegion extends PositionComponent
    with TapCallbacks, HoverCallbacks, HasGameRef<BaseGame> {
  PickUpRegion({required this.playerBroadcaster});

  final PlayerBroadcaster playerBroadcaster;

  @override
  void onTapDown(TapDownEvent event) {
    playerBroadcaster.tapPickUpRegion(
      withCards: gameRef.world
          .componentsAtPoint(absolutePosition)
          .whereType<CardBack>()
          .toList(),
    );
    removeFromParent();
  }
}
