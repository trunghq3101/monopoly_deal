import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class DealToPlayerBehavior extends Component
    with ParentIsA<PositionComponent>, Subscriber<CardDeckEvent> {
  DealToPlayerBehavior({Vector2? playerPosition})
      : _playerPosition = playerPosition ?? Vector2.zero();

  final Vector2 _playerPosition;

  @override
  void onNewEvent(CardDeckEvent event) {
    switch (event) {
      case CardDeckEvent.deal:
        parent.add(
          MoveEffect.to(
            _playerPosition,
            LinearEffectController(0.4),
          ),
        );
        break;
      default:
    }
  }
}
