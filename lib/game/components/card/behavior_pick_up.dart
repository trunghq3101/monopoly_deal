import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class PickUpBehavior extends Component
    with ParentIsA<Card>, Subscriber, Publisher {
  PickUpBehavior({double delayStep = 0.1}) : _delayStep = delayStep;

  final double _delayStep;

  @override
  void onNewEvent(Event event) {
    final payload = event.payload;
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.pickUpToHand:
        assert(payload is CardPickUpPayload);
        payload as CardPickUpPayload;
        final delay = payload.orderIndex * _delayStep;
        final frontImg = MainGame.gameAsset.frontImageForCardId(parent.cardId);
        final frontCard = SpriteComponent.fromImage(frontImg);
        frontCard.size = parent.size;
        parent.add(TimerComponent(
          period: delay + 0.3,
          removeOnFinish: true,
          onTick: () {
            parent.children.query<SpriteComponent>().first.removeFromParent();
            parent.add(frontCard);
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
              Vector2(0, MainGame.gameMap.overviewGameVisibleSize.y * 1.5),
              DelayedEffectController(
                CurvedEffectController(0.3, Curves.easeInCubic),
                delay: delay,
              ),
            ),
            MoveEffect.to(
              payload.inHandPosition.position,
              CurvedEffectController(0.4, Curves.easeInOutCubic),
              onComplete: () {
                notify(
                    Event(event.reverseEvent!)..payload = event.reversePayload);
              },
            ),
          ]),
          ScaleEffect.to(
            Vector2.all(MainGame.gameMap.cardSizeInHand.x /
                MainGame.gameMap.cardSize.x),
            DelayedEffectController(
              LinearEffectController(0.4),
              delay: delay + 0.3,
            ),
          )
        ]);
        break;
      default:
    }
  }
}
