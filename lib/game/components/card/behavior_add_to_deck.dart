import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class AddToDeckBehavior extends PublisherComponent
    with ParentIsA<PositionComponent>, Subscriber {
  AddToDeckBehavior({int index = 0, int priority = 0})
      : _index = index,
        _priority = priority;

  final int _index;
  final int _priority;

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardDeckEvent.showUp:
        parent.priority = _priority;
        parent.position = MainGame2.gameMap.inDeckPosition(0);
        parent.add(MoveEffect.to(
          MainGame2.gameMap.inDeckPosition(_index),
          LinearEffectController(0.6),
        ));
        add(TimerComponent(
            period: 0.6,
            removeOnFinish: true,
            onTick: () {
              notify(Event(CardEvent.addedToDeck));
              removeFromParent();
            }));
        break;
      default:
    }
  }
}
