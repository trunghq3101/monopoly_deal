import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class CardDeckPublisher extends PublisherComponent with Subscriber {
  int _addToDeckCount = 0;

  @override
  Future<void>? onLoad() async {
    TimerComponent(
      period: 0,
      removeOnFinish: true,
      onTick: () {
        notify(CardDeckEvent.showUp);
      },
    ).addToParent(this);
  }

  @override
  void onNewEvent(Object event, [Object? payload]) {
    if (event == CardEvent.addedToDeck) {
      _addToDeckCount++;

      if (_addToDeckCount == MainGame2.cardTotalAmount) {
        notify(CardDeckEvent.dealStartGame);
      }
    }
  }
}
