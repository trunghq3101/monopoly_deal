import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class MainGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  @override
  Future<void>? onLoad() async {
    final riveFile = RiveFile.asset('assets/images/btn_pause.riv');
    final artboard = await loadArtboard(
      riveFile,
      artboardName: 'pause-one',
    );
    final pauseIconComponent = RiveComponent(
      artboard: artboard,
      position: Vector2.all(0),
      size: Vector2.all(100),
    );
    await add(pauseIconComponent);
  }
}
