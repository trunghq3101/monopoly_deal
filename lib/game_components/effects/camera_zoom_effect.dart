import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';

class CameraZoomEffect extends Effect with EffectTarget<CameraComponent> {
  CameraZoomEffect.by(
    Vector2 size,
    super.controller, {
    super.onComplete,
  }) : _size = size;

  factory CameraZoomEffect.to(
    Vector2 size,
    EffectController controller, {
    void Function()? onComplete,
  }) {
    return _CameraZoomToEffect(
      size,
      controller,
      onComplete: onComplete,
    );
  }

  Vector2 _size;

  @override
  void apply(double progress) {
    final dProgress = progress - previousProgress;
    target.viewfinder.visibleGameSize =
        target.viewfinder.visibleGameSize! + _size * dProgress;
  }
}

class _CameraZoomToEffect extends CameraZoomEffect {
  _CameraZoomToEffect(
    Vector2 size,
    EffectController controller, {
    void Function()? onComplete,
  })  : _destinationSize = size,
        super.by(Vector2.zero(), controller, onComplete: onComplete);

  final Vector2 _destinationSize;

  @override
  void onStart() {
    _size = _destinationSize - target.viewfinder.visibleGameSize!;
  }
}
