import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:monopoly_deal/features/cards/hand.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

import '../features/cards/card.dart';
import '../features/cards/card_front.dart';
import 'effects/camera_zoom_effect.dart';

enum CameraState { initial }

enum MainGameState { initial }

const kMouseMove = 11;

class DealCameraTransition extends Transition<CameraState> {
  DealCameraTransition(super.dest, this.camera);

  final CameraComponent camera;

  @override
  FutureOr<void> onActivate(payload) {
    camera.add(CameraZoomEffect.to(
      Card.kCardSize * 7,
      LinearEffectController(1),
    ));
  }
}

class CardTargetingTransition extends Transition<MainGameState> {
  CardTargetingTransition(super.dest, this.game);

  final FlameGame game;

  CardFront? _lastTargeting;

  @override
  FutureOr<void> onActivate(payload) async {
    if (game.children
            .query<Hand>()
            .firstOrNull
            ?.positionMachine
            .current
            .identifier !=
        HandState.expanded) {
      return;
    }
    final PointerHoverInfo info = payload;
    final c = game
        .componentsAtPoint(info.eventPosition.viewport)
        .whereType<CardFront>()
        .firstOrNull;
    if (c == null || c.id != _lastTargeting?.id) {
      _lastTargeting?.onCommand(Command(CardFront.kMouseHoverLeft));
    }
    if (c != null) {
      c.onCommand(Command(CardFront.kMouseHover));
      _lastTargeting = c;
    }
  }
}
