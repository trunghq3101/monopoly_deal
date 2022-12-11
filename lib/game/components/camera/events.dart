import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

enum CameraEvent { toOverview }

class CardDeckEventToCameraEventAdapter
    with Publisher<CameraEvent>, Subscriber<CardDeckEvent> {
  @override
  void onNewEvent(CardDeckEvent event, [Object? payload]) {
    switch (event) {
      case CardDeckEvent.dealStartGame:
        notify(CameraEvent.toOverview);
        break;
      default:
    }
  }
}
