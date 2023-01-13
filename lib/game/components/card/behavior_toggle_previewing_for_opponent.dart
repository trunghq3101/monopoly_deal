import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class TogglePreviewingForOpponentBehavior extends Component
    with Subscriber, ParentIsA<Card> {
  PositionComponent? _inHandPlaceholder;
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case PacketType.cardPreviewed:
        final payload = event.payload as CardWithPlayer;
        if (payload.cardIndex != parent.cardIndex) return;
        _inHandPlaceholder = PositionComponent(
          angle: parent.angle,
          position: parent.position,
          scale: parent.scale,
        );
        parent.add(
          MoveEffect.by(Vector2(0, -200), LinearEffectController(0.1)),
        );
        break;
      case PacketType.cardUnpreviewed:
        final payload = event.payload as CardWithPlayer;
        if (payload.cardIndex != parent.cardIndex) return;
        if (_inHandPlaceholder == null) return;
        parent.add(
          MoveEffect.to(
              _inHandPlaceholder!.position, LinearEffectController(0.1)),
        );
        break;
      default:
    }
  }
}
