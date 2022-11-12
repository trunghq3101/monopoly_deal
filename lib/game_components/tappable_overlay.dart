import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';

import 'mixins.dart';

class TappableOverlay extends HudMarginComponent
    with TapCallbacks, HasGameReference<FlameGame> {
  TappableOverlay()
      : super(
          anchor: Anchor.center,
          position: Vector2.zero(),
          priority: kOverlayPriority1,
        );

  @override
  Future<void> onLoad() {
    game.children.register<TapOutsideCallback>();
    position = game.size / 2;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    size = gameSize;
    super.onGameResize(gameSize);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final c = game.children.query<TapOutsideCallback>().firstOrNull;
    if (c != null && c.tapOutsideSubscribed) {
      assert(game.children.query<TapOutsideCallback>().length == 1);
      if (!game.componentsAtPoint(event.canvasPosition).contains(c)) {
        c.onTapOutside();
        return;
      }
    }
    event.continuePropagation = true;
  }
}
