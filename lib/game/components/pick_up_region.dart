// ignore_for_file: invalid_override_of_non_virtual_member, annotate_overrides, invalid_use_of_internal_member

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/rendering.dart';
import 'package:monopoly_deal/game/game.dart';

class PickUpRegion extends PositionComponent
    with TapCallbacks, Hoverable, HasGameReference<BaseGame> {
  PickUpRegion({required this.playerBroadcaster});

  @override
  bool get isHovered => _isHovered;
  bool _isHovered = false;

  final PlayerBroadcaster playerBroadcaster;

  @override
  void onTapDown(TapDownEvent event) {
    playerBroadcaster.tapPickUpRegion(
      withCards: game.world
          .componentsAtPoint(absolutePosition)
          .whereType<CardBack>()
          .toList(),
    );
    game.mouseCursor = MouseCursor.defer;
    removeFromParent();
  }

  bool handleMouseMovement(PointerHoverInfo info) {
    final worldPoint = game.cameraComponent.viewfinder.transform
        .globalToLocal(info.eventPosition.viewport);
    if (containsLocalPoint(absoluteToLocal(worldPoint))) {
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
    game.mouseCursor = SystemMouseCursors.click;
    return super.onHoverEnter(info);
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    game.mouseCursor = MouseCursor.defer;
    return super.onHoverLeave(info);
  }
}
