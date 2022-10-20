import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'game_assets.dart';

class PauseButton extends RiveComponent
    with TapCallbacks, HasGameRef, ComponentViewportMargin {
  PauseButton()
      : super(
          artboard: loadArtboard,
          size: Vector2.all(50),
        ) {
    margin = const EdgeInsets.only(left: 10, top: 10);
  }

  static get loadArtboard =>
      gameAssets.riveFile('buttons').artboardByName('pause-one');

  late final RiveAnimationController _controller;

  @override
  Future<void> onLoad() {
    _controller = OneShotAnimation('Press', autoplay: false);
    artboard.addController(_controller);
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (gameRef.paused == true) return;
    _controller.isActive = true;
    _controller.isActiveChanged.addListener(_pauseGame);
    gameRef.overlays.add(Overlays.kPauseMenu);
  }

  void _pauseGame() {
    if (!_controller.isActive) {
      gameRef.pauseEngine();
      _controller.isActiveChanged.removeListener(_pauseGame);
    }
  }
}
