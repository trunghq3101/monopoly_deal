// ignore_for_file: invalid_use_of_internal_member

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

abstract class BaseGame extends FlameGame {
  World get world;
  CameraComponent get cameraComponent;

  Vector2 worldPosition(Vector2 globalPosition) =>
      cameraComponent.viewfinder.transform.globalToLocal(globalPosition);
}
