import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/widgets.dart';

import 'game_components/game_assets.dart';
import 'game_components/pause_button.dart';

class MainGame extends FlameGame with HasTappables {
  @override
  Color backgroundColor() => const Color(0xFFD74E30);

  @override
  Future<void>? onLoad() async {
    await gameAssets.preCache();
    final pauseIconComponent = PauseBtnComponent();
    await add(pauseIconComponent);
    final card = SvgComponent(
      svg: await Svg.load('card.svg'),
      position: Vector2.all(300),
      size: Vector2.all(100),
      anchor: Anchor.center,
    );
    add(card);
    camera.followComponent(card);
  }
}
