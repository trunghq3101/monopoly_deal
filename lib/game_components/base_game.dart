import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:monopoly_deal/main_dashbook.dart';

import 'game_assets.dart';

class BaseGame extends FlameGame with HasTappableComponents {
  late final World world;
  late final CameraComponent cameraComponent;
  late final Viewfinder viewfinder;
  late final Viewport viewport;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;

  @override
  void onTapDown(TapDownEvent event) {
    print('game tapped');
    super.onTapDown(event);
    for (var c in children.query<TapOutsideCallback>()) {
      c.onTapOutside();
    }
  }

  @override
  Future<void> onLoad() async {
    await gameAssets.preCache();
    world = World();
    cameraComponent = CameraComponent(world: world);
    viewport = cameraComponent.viewport;
    viewfinder = cameraComponent.viewfinder;
    await addAll([world, cameraComponent]);
  }
}

const kLoadingTime = Duration(milliseconds: 500);

extension DebugGame on BaseGame {
  onDebug(FutureOr<dynamic> Function(BaseGame game) body) {
    debugMode = true;
    onLoaded((game) {
      add(FpsTextComponent(position: Vector2(0, game.size.y - 24)));
      body(game);
    });
  }

  onLoaded(FutureOr<dynamic> Function(BaseGame game) body) {
    Future.delayed(kLoadingTime, () => body(this));
  }
}
