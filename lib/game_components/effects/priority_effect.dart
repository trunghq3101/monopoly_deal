import 'package:flame/effects.dart';

class PriorityEffect extends ComponentEffect {
  PriorityEffect.by(
    int priority,
    super.controller, {
    super.onComplete,
  }) : _priority = priority;

  factory PriorityEffect.to(
    int priority,
    EffectController controller, {
    void Function()? onComplete,
  }) {
    return _PriorityToEffect(
      priority,
      controller,
      onComplete: onComplete,
    );
  }

  int _priority;

  @override
  void apply(double progress) {
    final deltaProgress = progress - previousProgress;
    target.priority += (_priority * deltaProgress).ceil();
  }
}

class _PriorityToEffect extends PriorityEffect {
  _PriorityToEffect(
    int priority,
    EffectController controller, {
    void Function()? onComplete,
  })  : _destinationPriority = priority,
        super.by(0, controller, onComplete: onComplete);

  final int _destinationPriority;

  @override
  void onStart() {
    _priority = _destinationPriority - target.priority;
  }
}
