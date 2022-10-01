import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class PauseBtnComponent extends RiveComponent with Tappable {
  PauseBtnComponent({required super.artboard})
      : super(
          position: Vector2.all(0),
          size: Vector2.all(50),
        );

  late final RiveAnimationController _controller;

  @override
  Future<void>? onLoad() {
    _controller = OneShotAnimation('Press', autoplay: false);
    artboard.addController(_controller);
    return super.onLoad();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    _controller.isActive = true;
    return true;
  }
}

class MainGame extends FlameGame with HasTappables {
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  @override
  Future<void>? onLoad() async {
    final riveFile = RiveFile.asset('assets/images/buttons.riv');
    final artboard = await loadArtboard(
      riveFile,
      artboardName: 'pause-one',
    );
    final pauseIconComponent = PauseBtnComponent(artboard: artboard);
    await add(pauseIconComponent);
  }
}
