import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ToTableForOpponentBehavior extends Component
    with ParentIsA<Card>, Subscriber {
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
          },
          removeOnFinish: true,
        ));
        parent.addAll([
          ScaleEffect.to(Vector2.all(0.2), LinearEffectController(0.2)),
          MoveEffect.by(Vector2(0, 700), LinearEffectController(0.2))
        ]);

        MainGame.gameAsset.onCardRevealed(payload.cardIndex, payload.cardId);
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
