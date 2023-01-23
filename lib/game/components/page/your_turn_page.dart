import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';

class YourTurnRoute extends ValueRoute<void> {
  YourTurnRoute() : super(value: null, transparent: true);

  @override
  Component build() {
    return PausePage();
  }

  @override
  void onPush(Route? previousRoute) {
    previousRoute!.addRenderEffect(
      PaintDecorator.grayscale(opacity: 0.5)..addBlur(3.0),
    );
  }

  @override
  void didPop(Route previousRoute) {
    previousRoute.removeRenderEffect();
    super.didPop(previousRoute);
  }
}

class PausePage extends Component
    with TapCallbacks, HasGameReference<FlameGame> {
  @override
  Future<void> onLoad() async {
    addAll([
      TextComponent(
        text: 'YOUR TURN',
        position: game.canvasSize / 2,
        anchor: Anchor.center,
        children: [
          ScaleEffect.to(
            Vector2.all(1.1),
            EffectController(
              duration: 0.3,
              alternate: true,
              infinite: true,
            ),
          )
        ],
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) =>
      game.children.query<RouterComponent>().first.pop();
}
