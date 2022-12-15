import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';
import 'package:monopoly_deal/game/logic/randomize_deal_offset.dart';

class DealToPlayerBehavior extends Component
    with ParentIsA<PositionComponent>, Subscriber {
  DealToPlayerBehavior(
      {double delayStep = 0.2, RandomizeDealOffset? randomizeDealOffset})
      : _delayStep = delayStep,
        _randomizeDealOffset = randomizeDealOffset ?? RandomizeDealOffset();

  final double _delayStep;
  final RandomizeDealOffset _randomizeDealOffset;

  @override
  void onNewEvent(Object event, [Object? payload]) {
    switch (event) {
      case CardStateMachineEvent.toDealRegion:
        assert(payload is CardDealPayload);
        payload as CardDealPayload;
        final randomOffset = _randomizeDealOffset.generate();
        final delay = payload.orderIndex * _delayStep;
        parent.addAll([
          MoveEffect.to(
            payload.playerPosition + randomOffset,
            EffectController(
              duration: 0.4,
              curve: Curves.fastOutSlowIn,
              startDelay: delay,
            ),
          ),
          RotateEffect.by(
            pi + randomOffset.x % pi,
            EffectController(
              duration: 0.4,
              curve: Curves.fastOutSlowIn,
              startDelay: delay,
            ),
          ),
          TimerComponent(
            onTick: () {
              parent.priority = payload.orderIndex;
            },
            period: delay + 0.2,
            removeOnFinish: true,
          )
        ]);
        add(RemoveEffect(delay: delay + 0.5));
        break;
      default:
    }
  }
}
