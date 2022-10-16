import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';

class VisibleGameSizeEffect extends Effect with EffectTarget<Viewfinder> {
  VisibleGameSizeEffect.by(
    Vector2 size,
    super.controller, {
    super.onComplete,
  }) : _size = size;

  factory VisibleGameSizeEffect.to(
    Vector2 size,
    EffectController controller, {
    void Function()? onComplete,
  }) {
    return _VisibleGameSizeToEffect(
      size,
      controller,
      onComplete: onComplete,
    );
  }

  Vector2 _size;

  @override
  void apply(double progress) {
    final dProgress = progress - previousProgress;
    target.visibleGameSize!.add(_size * dProgress);
    target.onGameResize(target.findGame()!.size);
  }
}

class _VisibleGameSizeToEffect extends VisibleGameSizeEffect {
  _VisibleGameSizeToEffect(
    Vector2 size,
    EffectController controller, {
    void Function()? onComplete,
  })  : _destinationSize = size,
        super.by(Vector2.zero(), controller, onComplete: onComplete);

  final Vector2 _destinationSize;

  @override
  void onStart() {
    _size = _destinationSize - target.visibleGameSize!;
  }
}
