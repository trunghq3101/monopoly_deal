import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/state_machine/state_machine.dart';

import 'card_publisher.dart';

enum CardPlace {
  inHand,
  onTheTable,
}

enum CardFrontState {
  initial,
  inHand,
  previewing,
  onTheTable,
}

class CardFront extends SpriteComponent
    with HoverCallbacks, TapCallbacks, HasGameRef<BaseGame> {
  CardFront({
    required this.id,
  });

  final int id;
  CardPlace cardPlace = CardPlace.inHand;
  final _cardStateMachine = StateMachine<CardFrontState, GameEvent>();

  @override
  Future<void>? onLoad() async {
    sprite = gameAssets.cardSprites[id];
  }

  @override
  void onMount() {
    super.onMount();
    _cardStateMachine.setup({
      CardFrontState.initial: {
        GameEvent.handUp: EventAction((_) {}, CardFrontState.inHand)
      },
      CardFrontState.previewing: {
        GameEvent.tapCardFront: EventAction(
          (event) {
            gameRef.children
                .query<Player>()
                .firstOrNull
                ?.handle(Event(GameEvent.tapPreviewingCard, event.payload));
          },
          CardFrontState.inHand,
        ),
        GameEvent.playCard: EventAction(
          (event) {},
          CardFrontState.onTheTable,
        ),
      },
      CardFrontState.onTheTable: {}
    });
  }

  void handle(Event<GameEvent> event) {
    _cardStateMachine.handle(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    children.query<CardPublisher>().first.notify(CardEvent.tapped);
    handle(Event(GameEvent.tapCardFront, id));
  }

  @override
  void onHoverEnter(int hoverId) {
    super.onHoverEnter(hoverId);
    if (cardPlace == CardPlace.onTheTable) {
      return;
    }
    decorator.addLast(GlowingDecorator(
      component: this,
      spread: 40,
      radius: const Radius.circular(56),
      color: const Color.fromARGB(255, 147, 252, 241),
      sigma: 10,
    ));
  }

  @override
  void onHoverLeave() {
    super.onHoverLeave();
    decorator.removeLast();
  }

  static List<CardFront> findCardsInHand(BaseGame game) => game.world.children
      .query<CardFront>()
      .where((c) => c.cardPlace == CardPlace.inHand)
      .toList();
  static CardFront findById(BaseGame game, int id) =>
      game.world.children.query<CardFront>().firstWhere((e) => e.id == id);

  void changePlace(CardPlace place) {
    cardPlace = place;
  }
}

enum CardFrontEvent {
  tapped,
}
