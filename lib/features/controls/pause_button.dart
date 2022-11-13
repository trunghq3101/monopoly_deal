import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart';

import '../../game_components/game_assets.dart';

class PauseButton extends RiveComponent with TapCallbacks, HasGameRef {
  PauseButton()
      : super(
            artboard: loadArtboard,
            priority: kOverlayPriority0,
            position: Vector2.all(10));

  @override
  PositionType get positionType => PositionType.viewport;

  static get loadArtboard =>
      gameAssets.riveFile('buttons').artboardByName('pause-one');

  late final RiveAnimationController _controller;

  @override
  Future<void> onLoad() async {
    _controller = OneShotAnimation('Press', autoplay: false);
    artboard.addController(_controller);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (gameRef.paused == true) return;
    _controller.isActive = true;
    _controller.isActiveChanged.addListener(_pauseGame);
    gameRef.overlays.add(Overlays.kPauseMenu);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = Vector2.all(min(50, min(size.x / 7, size.y / 7)));
  }

  void _pauseGame() {
    if (!_controller.isActive) {
      gameRef.pauseEngine();
      _controller.isActiveChanged.removeListener(_pauseGame);
    }
  }
}
