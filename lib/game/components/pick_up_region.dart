// ignore_for_file: invalid_override_of_non_virtual_member, annotate_overrides, invalid_use_of_internal_member

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';
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
    gameRef.mouseCursor = MouseCursor.defer;
    removeFromParent();
  }

  @override
  void onHoverEnter(int hoverId) {
    super.onHoverEnter(hoverId);
    gameRef.mouseCursor = SystemMouseCursors.click;
  }

  @override
  void onHoverLeave() {
    gameRef.mouseCursor = MouseCursor.defer;
  }
}
