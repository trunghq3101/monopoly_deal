import 'dart:async';

import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

import 'card.dart';
import 'effects/camera_zoom_effect.dart';

enum CameraState { initial }

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
