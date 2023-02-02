import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class DiscardArea extends PositionComponent
    with Subscriber, Publisher, HasGameReference<FlameGame>, HasGamePage {
  DiscardArea({required this.cardTracker});

  final CardTracker cardTracker;

  @override
  Future<void>? onLoad() async {
    add(TimerComponent(
      period: 0.2,
      removeOnFinish: true,
      onTick: () {
        final cards = world.children
            .query<Card>()
            .where((e) => e.state == CardState.inDiscardToEndTurn);
        for (var c in cards) {
          final cardStateMachine = (c).children.query<CardStateMachine>().first;
          cardStateMachine.addSubscriber(this);
          addSubscriber(cardStateMachine);
        }
      },
    ));
    size = Vector2(
      MainGame.gameMap.overviewGameVisibleSize.x * 0.8,
      MainGame.gameMap.overviewGameVisibleSize.y * 0.4,
    );
    anchor = Anchor.center;
    priority = 10006;
    addAll([
      RectangleComponent(
        position: size / 2,
        size: size,
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFFFFFFFF),
      ),
      RectangleComponent(
        position: size / 2,
        size: MainGame.gameMap.cardSizeInHand,
        anchor: Anchor.center,
        paint: Paint()
          ..color = const Color.fromARGB(255, 87, 87, 87)
          ..style = PaintingStyle.stroke,
      ),
      ButtonComponent(
        text: "Discard",
        textAlign: TextAlign.center,
        tapDown: (_) {
          notify(Event(DiscardAreaEvent.discard));
          final cardsInHand = cardTracker.allCards
              .where((e) => e.state == CardState.inWaitingForDiscard)
              .toList();
          int orderIndex = 0;
          for (var c in cardsInHand) {
            final newInHandPosition = cardTracker.getInHandPosition(
              index: orderIndex,
              amount: cardsInHand.length,
            );
            orderIndex++;
            notify(
              Event(CardEvent.reposition)
                ..payload = CardRepositionPayload(
                  c.cardIndex,
                  inHandPosition: newInHandPosition,
                ),
            );
          }
          removeFromParent();
          gameMaster.roomGateway.endTurn();
        },
      )
        ..position = Vector2(
          width * 0.1 * (1 + 3.5 + 1 + 1.75),
          height * 0.9,
        )
        ..anchor = Anchor.center
        ..size = MainGame.gameMap.buttonSize,
      ButtonComponent(
        text: "Cancel",
        textAlign: TextAlign.center,
        tapDown: (_) {
          notify(Event(DiscardAreaEvent.cancel));
          removeFromParent();
        },
      )
        ..position = Vector2(
          width * 0.1 * (1 + 1.75),
          height * 0.9,
        )
        ..anchor = Anchor.center
        ..size = MainGame.gameMap.buttonSize,
    ]);
  }

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.toSelectingForDiscard:
        final inDiscardToEndTurn = world.children
            .query<Card>()
            .where((c) => c.state == CardState.inDiscardToEndTurn);
        if (inDiscardToEndTurn.length <= 7) {
          for (var c in inDiscardToEndTurn) {
            notify(Event(CardEvent.toWaitingForDiscard)
              ..payload = CardIndexPayload(c.cardIndex));
          }
        }
        break;
      default:
    }
  }
}
