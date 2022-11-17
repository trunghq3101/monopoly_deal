import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

abstract class BaseGame extends FlameGame {
  World get world;
  CameraComponent get cameraComponent;
}
