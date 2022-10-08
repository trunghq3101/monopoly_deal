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
    final pauseIconComponent = PauseBtnComponent();
    final card = Card(svg: await Svg.load('card.svg'));
    final world = World()..add(card);
    await add(world);
    final camera = CameraComponent(world: world)
      ..viewport.add(pauseIconComponent)
      ..viewfinder.visibleGameSize = Vector2(1200, 1200)
      ..follow(card);
    await add(camera);
  }
}
