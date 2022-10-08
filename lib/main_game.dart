import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/widgets.dart';

import 'game_components/card.dart';
import 'game_components/game_assets.dart';
import 'game_components/pause_button.dart';

class MainGame extends FlameGame with HasTappables {
  @override
  Color backgroundColor() => const Color(0xFFD74E30);

  @override
  Future<void>? onLoad() async {
    await gameAssets.preCache();
    final pauseButton = PauseButton();
    final world = World();
    final card = Card(svg: await Svg.load('card.svg'));
    final camera = CameraComponent(world: world);
    camera.viewfinder.visibleGameSize = Card.kCardSize * 1.2;

    children
      ..register<World>()
      ..register<CameraComponent>();
    camera.viewport.children.register<PauseButton>();
    world.children.register<Card>();
    await addAll([world, camera]);
    await world.add(card);
    await camera.viewport.add(pauseButton);

    camera.follow(card);
  }
}
