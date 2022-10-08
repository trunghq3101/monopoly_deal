import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'game_assets.dart';

class PauseBtnComponent extends RiveComponent
    with Tappable, HasGameRef, ComponentViewportMargin {
  PauseBtnComponent()
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
  bool onTapDown(TapDownInfo info) {
    if (gameRef.paused == true) return true;
    _controller.isActive = true;
    _controller.isActiveChanged.addListener(_pauseGame);
    gameRef.overlays.add(Overlays.kPauseMenu);
    return true;
  }

  void _pauseGame() {
    if (!_controller.isActive) {
      gameRef.pauseEngine();
      _controller.isActiveChanged.removeListener(_pauseGame);
    }
  }
}
