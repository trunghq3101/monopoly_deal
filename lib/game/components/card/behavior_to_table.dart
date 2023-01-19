import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ToTableBehavior extends Component
    with ParentIsA<Card>, Subscriber, HasGameReference<FlameGame> {
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.toTable:
        game.children.query<GameMaster>().firstOrNull?.play(parent.cardIndex);
        add(TimerComponent(
          period: 0.2,
          onTick: () {
            parent.priority = 0;
            _updateSetCounter(parent.cardIndex);
          },
          removeOnFinish: true,
        ));
        parent.addAll([
          ScaleEffect.to(Vector2.all(1), LinearEffectController(0.2)),
          MoveEffect.to(_postionToPlaceCard(parent.cardIndex),
              LinearEffectController(0.2))
        ]);
        break;
      default:
    }
  }

  Vector2 _postionToPlaceCard(int index) {
    final cardType = MainGame.gameAsset.indexToCardType(index);
    final actionCardPosition = (MainGame.gameMap.deckCenter + Vector2(500, 0));
    if (cardType > 10) return actionCardPosition;
    final playArea = game.children
        .query<World>()
        .firstOrNull
        ?.children
        .query<PlayArea>()
        .elementAtOrNull(0);
    return playArea?.children
            .query<RectangleComponent>()
            .elementAtOrNull(cardType - 1)
            ?.absolutePosition ??
        actionCardPosition;
  }

  void _updateSetCounter(int cardIndex) {
    final cardType = MainGame.gameAsset.indexToCardType(cardIndex);
    if (cardType > 10) return;
    final playArea = game.children
        .query<World>()
        .firstOrNull
        ?.children
        .query<PlayArea>()
        .elementAtOrNull(0);
    playArea?.children
        .query<SetCounter>()
        .elementAtOrNull(cardType - 1)
        ?.newPlayedCard();
  }
}
