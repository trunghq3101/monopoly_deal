import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class RevealCardBehavior extends Component with ParentIsA<Card>, Subscriber {
  @override
  void onNewEvent(Event event) {
    if (event.eventIdentifier == CardEvent.cardRevealed) {
      final payload = event.payload as CardIndexPayload;
      if (payload.cardIndex != parent.cardIndex) return;
      final frontImg =
          MainGame.gameAsset.frontImageForCardIndex(parent.cardIndex);
      final frontCard = SpriteComponent.fromImage(frontImg);
      frontCard.size = parent.size;
      add(TimerComponent(
        period: 0.6,
        removeOnFinish: true,
        onTick: () {
          parent.children.query<SpriteComponent>().first.removeFromParent();
          parent.add(frontCard);
        },
      ));
    }
  }
}
