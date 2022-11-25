import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';

class CameraMan extends Component with HasGameRef<BaseGame> {
  void zoomOutToSize(Vector2 visibleGameSize) {
    CameraZoomEffectTo(visibleGameSize, LinearEffectController(1))
        .addToParent(gameRef.cameraComponent);
    MoveEffect.to(Vector2(0, GameSize.visibleAfterDealing.y / 2),
            LinearEffectController(1))
        .addToParent(gameRef.cameraComponent.viewfinder);
    AnchorEffect.to(Anchor.bottomCenter, LinearEffectController(1))
        .addToParent(gameRef.cameraComponent.viewfinder);
  }
}
