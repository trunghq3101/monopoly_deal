import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

import '../../game_components/game_assets.dart';
import '../cards/card.dart';
import '../cards/card_front.dart';
import '../cards/hand.dart';

class DealTarget extends PositionComponent {
  DealTarget({super.position, super.size, super.anchor});
}

class PickUpRegionTransition extends Transition<PickUpRegionState> {
  PickUpRegionTransition(super.dest, this.region);

  final PickUpRegion region;

  @override
  FutureOr<void> onActivate(payload) {
    var delay = 0.0;
    final cards = region.children.query<Card>().reversed;
    for (var c in cards) {
      c.onCommand(Command(Card.kPickUp, delay += 0.1));
    }
    final hand = region.game.children.query<Hand>().firstOrNull;
    region.add(TimerComponent(
      period: 0.8,
      removeOnFinish: true,
      onTick: () {
        hand?.onCommand(Command(
            Hand.kPickUp,
            cards
                .map(
                  (e) => CardFront(
                    id: e.id,
                    sprite: gameAssets.cardSprites[e.id],
                    size: Vector2(hand.size.x * 0.5,
                        hand.size.x * 0.5 * Card.kCardHeight / Card.kCardWidth),
                    anchor: Anchor.topCenter,
                  ),
                )
                .toList()));
      },
    ));
  }
}

enum PickUpRegionState { initial, pickedUp }

class PickUpRegion extends DealTarget
    with TapCallbacks, HasStateMachine, HasGameReference<FlameGame> {
  PickUpRegion({super.position, super.size, super.anchor});

  static const kPickUp = 0;

  @override
  Future<void>? onLoad() async {
    newMachine({
      PickUpRegionState.initial: {
        Command(kPickUp):
            PickUpRegionTransition(PickUpRegionState.pickedUp, this)
      },
      PickUpRegionState.pickedUp: {}
    });
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onCommand(Command(kPickUp));
  }
}
