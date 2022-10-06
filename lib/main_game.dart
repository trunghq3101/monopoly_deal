import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'game_components/game_assets.dart';
import 'game_components/pause_button.dart';

class MainGame extends FlameGame with HasTappables {
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  @override
  Future<void>? onLoad() async {
    await gameAssets.load();
    final pauseIconComponent = PauseBtnComponent();
    await add(pauseIconComponent);
  }
}
