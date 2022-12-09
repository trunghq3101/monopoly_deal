import 'package:flame/components.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class CardDeckPublisher extends Component with Publisher<CardDeckEvent> {
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
}

enum CardDeckEvent { showUp }
