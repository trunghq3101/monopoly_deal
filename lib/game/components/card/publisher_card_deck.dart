import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class CardDeckPublisher extends PublisherComponent<CardDeckEvent>
    with Subscriber<AddToDeckEvent> {
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
  void onNewEvent(AddToDeckEvent event, [Object? payload]) {
    if (event == AddToDeckEvent.done) {
      _addToDeckCount++;

      if (_addToDeckCount == MainGame2.cardTotalAmount) {
        notify(CardDeckEvent.dealStartGame);
      }
    }
  }
}

enum CardDeckEvent { showUp, dealStartGame }
