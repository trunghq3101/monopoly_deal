import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ToTableBehavior extends Component
    with ParentIsA<Card>, Subscriber, HasGameReference<FlameGame> {
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.toTable:
        game.children
            .query<RoomGatewayComponent>()
            .firstOrNull
            ?.roomGateway
            .sendCardEvent(PacketType.playCard, parent.cardIndex);
        add(TimerComponent(
          period: 0.2,
          onTick: () {
            parent.priority = 0;
          },
          removeOnFinish: true,
        ));
        parent.addAll([
          ScaleEffect.to(Vector2.all(1), LinearEffectController(0.2)),
          MoveEffect.to(Vector2(0, 700), LinearEffectController(0.2))
        ]);
        break;
      default:
    }
  }
}
