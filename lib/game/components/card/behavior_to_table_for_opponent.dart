import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ToTableForOpponentBehavior extends Component
    with ParentIsA<Card>, Subscriber, HasGameReference<FlameGame>, HasGamePage {
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case PacketType.cardPlayed:
        final payload = event.payload as CardInfoWithPlayer;
        if (payload.cardIndex != parent.cardIndex) return;
        add(TimerComponent(
          period: 0.2,
          onTick: () {
            parent.priority = 0;
            _updateSetCounter(payload.playerId, payload.cardIndex);
          },
          removeOnFinish: true,
        ));

        MainGame.gameAsset.onCardRevealed(payload.cardIndex, payload.cardId);

        parent.addAll([
          RotateEffect.to(0, LinearEffectController(0.2)),
          ScaleEffect.to(Vector2.all(1), LinearEffectController(0.2)),
          MoveEffect.to(
              _postionToPlaceCard(payload.playerId, payload.cardIndex),
              LinearEffectController(0.2))
        ]);

        final frontImg =
            MainGame.gameAsset.frontImageForCardIndex(payload.cardIndex);
        final frontCard = SpriteComponent.fromImage(frontImg);
        frontCard.size = parent.size;
        parent.children.query<SpriteComponent>().first.removeFromParent();
        parent.add(frontCard);
        break;
      default:
    }
  }

  void _updateSetCounter(String playerId, int cardIndex) {
    final roomGateway = gameMaster.roomGateway;
    final relativePlayerIndex =
        roomGateway.relativePlayerIndex(roomGateway.playerIndexOf(playerId));
    final cardType = MainGame.gameAsset.indexToCardType(cardIndex);
    if (cardType > 10) return;
    final playArea = world.children
        .query<PlayArea>()
        .elementAtOrNull(relativePlayerIndex + 1);
    playArea?.children
        .query<SetCounter>()
        .elementAtOrNull(cardType - 1)
        ?.newPlayedCard();
  }

  Vector2 _postionToPlaceCard(String playerId, int cardIndex) {
    final roomGateway = gameMaster.roomGateway;
    final relativePlayerIndex =
        roomGateway.relativePlayerIndex(roomGateway.playerIndexOf(playerId));
    final cardType = MainGame.gameAsset.indexToCardType(cardIndex);
    final actionCardPosition = (MainGame.gameMap.deckCenter + Vector2(500, 0));
    if (cardType > 10) return actionCardPosition;
    final playArea = world.children
        .query<PlayArea>()
        .elementAtOrNull(relativePlayerIndex + 1);
    return playArea?.children
            .query<RectangleComponent>()
            .elementAtOrNull(cardType - 1)
            ?.absolutePosition ??
        actionCardPosition;
  }
}
