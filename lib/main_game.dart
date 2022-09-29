import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/widgets.dart';

class MainGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  @override
  Future<void>? onLoad() async {
    final pauseIcon = await Svg.load('images/ic_pause.svg');
    final pauseIconComponent = SvgComponent(
      svg: pauseIcon,
      position: Vector2.all(0),
      size: Vector2.all(100),
    );
    await add(pauseIconComponent);
  }
}
