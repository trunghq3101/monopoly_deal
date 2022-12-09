import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class TogglePreviewingBehavior extends Component
    with Subscriber<CardStateMachineEvent>, ParentIsA<PositionComponent> {
  PositionComponent? _inHandPlaceholder;
  @override
  void onNewEvent(CardStateMachineEvent event) {
    switch (event) {
      case CardStateMachineEvent.toPreviewing:
        _inHandPlaceholder = PositionComponent(
          angle: parent.angle,
          position: parent.position,
        );
        parent.addAll([
          MoveEffect.to(
              GamePosition.previewCard.position, LinearEffectController(0.1)),
          RotateEffect.to(0, LinearEffectController(0.1)),
          ScaleEffect.by(Vector2.all(1.6), LinearEffectController(0.1)),
        ]);
        break;
      case CardStateMachineEvent.toHand:
        if (_inHandPlaceholder == null) return;
        parent.addAll([
          MoveEffect.to(
              _inHandPlaceholder!.position, LinearEffectController(0.1)),
          RotateEffect.to(
              _inHandPlaceholder!.angle, LinearEffectController(0.1)),
          ScaleEffect.to(Vector2.all(1), LinearEffectController(0.1)),
        ]);
        break;
      default:
    }
  }
}
