import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class PickUpBehavior extends Component
    with ParentIsA<Card>, Subscriber<CardStateMachineEvent> {
  @override
  void onNewEvent(CardStateMachineEvent event, [Object? payload]) {
    switch (event) {
      case CardStateMachineEvent.toHand:
        parent.children.query<SpriteComponent>().first.removeFromParent();
        final frontImg = MainGame2.gameAsset.frontImageForCardId(parent.cardId);
        final frontCard = SpriteComponent.fromImage(frontImg);
        frontCard.size = parent.size;
        parent.add(frontCard);
        break;
      default:
    }
  }
}
