import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';

class CameraZoomEffectTo extends Effect with EffectTarget<CameraComponent> {
  CameraZoomEffectTo(
    Vector2 size,
    EffectController controller, {
    void Function()? onComplete,
  })  : _destinationSize = size,
        super(controller, onComplete: onComplete);

  final Vector2 _destinationSize;
  late Vector2 _difference;

  @override
  void onStart() {
    assert(target.viewfinder.visibleGameSize != null,
        "Must set CameraComponent.Viewfinder.visibleGameSize beforehand");
    final v = target.viewfinder.visibleGameSize!;
    _difference = _destinationSize - v;
  }

  @override
  void apply(double progress) {
    final dProgress = progress - previousProgress;
    target.viewfinder.visibleGameSize =
        target.viewfinder.visibleGameSize! + _difference * dProgress;
  }
}
