import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ToDiscardForOpponentBehavior extends Component
    with ParentIsA<Card>, Subscriber, HasGameReference<FlameGame>, HasGamePage {
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case PacketType.discarded:
        final payload = event.payload as CardInfoWithPlayer;
        if (payload.cardIndex != parent.cardIndex) return;
        add(TimerComponent(
          period: 0.2,
          onTick: () {
            parent.priority = 0;
          },
          removeOnFinish: true,
        ));

        MainGame.gameAsset.onCardRevealed(payload.cardIndex, payload.cardId);

        parent.addAll([
          ScaleEffect.to(Vector2.all(1), LinearEffectController(0.2)),
          MoveEffect.to((MainGame.gameMap.deckCenter + Vector2(500, 0)),
              LinearEffectController(0.2)),
          RotateEffect.to(0, LinearEffectController(0.2)),
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
}
