import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class PickUpForOpponentBehavior extends Component
    with ParentIsA<Card>, Subscriber, Publisher, HasGameReference<FlameGame> {
  PickUpForOpponentBehavior({double delayStep = 0.1}) : _delayStep = delayStep;

  final double _delayStep;

  @override
  void onNewEvent(Event event) {
    final payload = event.payload;
    switch (event.eventIdentifier) {
      case CardEvent.pickUpForOpponent:
        assert(payload is CardPickUpPayload);
        payload as CardPickUpPayload;
        if (payload.cardIndex != parent.cardIndex) return;
        final delay = payload.orderIndex * _delayStep;
        parent.add(TimerComponent(
          period: delay + 0.3,
          removeOnFinish: true,
          onTick: () {
            parent.priority = parent.priority + 1;
          },
        ));
        parent.addAll([
          SequenceEffect([
            RotateEffect.to(
              0,
              DelayedEffectController(
                LinearEffectController(0.1),
                delay: delay,
              ),
            ),
            RotateEffect.to(
              payload.inHandPosition.angle,
              CurvedEffectController(0.4, Curves.easeInOutCubic),
            )
          ]),
          SequenceEffect([
            MoveEffect.to(
              Vector2(0, MainGame.gameMap.overviewGameVisibleSize.y * -1.5),
              DelayedEffectController(
                CurvedEffectController(0.3, Curves.easeInCubic),
                delay: delay,
              ),
            ),
            MoveEffect.to(
              payload.inHandPosition.position,
              CurvedEffectController(0.4, Curves.easeInOutCubic),
            ),
          ]),
        ]);
        break;
      default:
    }
  }
}
