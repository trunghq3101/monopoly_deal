import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../game_components/mixins.dart';

class TestComponent1 extends PositionComponent
    with TapCallbacks, TapOutsideCallback {
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    tapOutsideEnabled = true;
    scale = Vector2.all(1);
    print('Component tapped');
  }

  @override
  void onTapOutside() {
    tapOutsideEnabled = false;
    scale = Vector2.all(0.5);
    print('Component outside');
  }
}

class TestComponent2 extends PositionComponent with TapCallbacks {
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    size = size * 0.8;
    print('Other tapped');
  }
}
