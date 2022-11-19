// ignore_for_file: invalid_override_of_non_virtual_member, annotate_overrides, invalid_use_of_internal_member

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/rendering.dart';
import 'package:monopoly_deal/game/game.dart';

class PickUpRegion extends PositionComponent
    with TapCallbacks, Hoverable, HasGameRef<BaseGame> {
  PickUpRegion({required this.playerBroadcaster});

  @override
  bool get isHovered => _isHovered;
  bool _isHovered = false;

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

  bool handleMouseMovement(PointerHoverInfo info) {
    final worldPosition = gameRef.worldPosition(info.eventPosition.viewport);
    if (containsLocalPoint(absoluteToLocal(worldPosition))) {
      if (!_isHovered) {
        _isHovered = true;
        return onHoverEnter(info);
      }
    } else {
      if (_isHovered) {
        _isHovered = false;
        return onHoverLeave(info);
      }
    }
    return true;
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    gameRef.mouseCursor = SystemMouseCursors.click;
    return super.onHoverEnter(info);
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    gameRef.mouseCursor = MouseCursor.defer;
    return super.onHoverLeave(info);
  }
}
