import 'package:flame/components.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class CardDeckPublisher extends PublisherComponent<CardDeckEvent> {
  @override
  Future<void>? onLoad() async {
    TimerComponent(
      period: 0,
      removeOnFinish: true,
      onTick: () {
        notify(CardDeckEvent.showUp);
      },
    ).addToParent(this);
    TimerComponent(
      period: 1,
      removeOnFinish: true,
      onTick: () {
        notify(CardDeckEvent.dealStartGame);
      },
    ).addToParent(this);
  }
}

enum CardDeckEvent { showUp, dealStartGame, deal }
