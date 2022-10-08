import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart';

import 'game_assets.dart';

class PauseBtnComponent extends RiveComponent with Tappable {
  PauseBtnComponent()
      : super(
          artboard: loadArtboard,
          position: Vector2.all(0),
          size: Vector2.all(50),
        );

  static get loadArtboard =>
      gameAssets.riveFile('buttons').artboardByName('pause-one');

  late final RiveAnimationController _controller;

  @override
  Future<void>? onLoad() {
    _controller = OneShotAnimation('Press', autoplay: false);
    artboard.addController(_controller);
    return super.onLoad();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (findGame()?.paused == true) return true;
    _controller.isActive = true;
    _controller.isActiveChanged.addListener(_pauseGame);
    findGame()?.overlays.add(Overlays.kPauseMenu);
    return true;
  }

  void _pauseGame() {
    if (!_controller.isActive) {
      findGame()?.pauseEngine();
      _controller.isActiveChanged.removeListener(_pauseGame);
    }
  }
}
