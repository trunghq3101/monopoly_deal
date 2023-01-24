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
  bool _tapEnabled = false;
  @override
  Future<void> onLoad() async {
    addAll([
      TimerComponent(
        period: 0.5,
        removeOnFinish: true,
        onTick: () {
          _tapEnabled = true;
        },
      ),
      TextComponent(
        text: 'YOUR TURN',
        position: game.canvasSize / 2,
        anchor: Anchor.center,
        scale: Vector2.zero(),
        children: [
          SequenceEffect([
            ScaleEffect.to(Vector2.all(1.1), LinearEffectController(0.5)),
            ScaleEffect.to(
              Vector2.all(1),
              EffectController(
                duration: 0.3,
                alternate: true,
                infinite: true,
              ),
            )
          ])
        ],
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) {
    if (!_tapEnabled) return;
    game.children.query<RouterComponent>().first.pop();
  }
}
