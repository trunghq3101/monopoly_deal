import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ZoomOverviewBehavior extends Component
    with ParentIsA<CameraComponent>, Subscriber {
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardDeckEvent.dealStartGame:
        parent.add(CameraZoomEffectTo(
          MainGame.gameMap.overviewGameVisibleSize2,
          LinearEffectController(1),
        ));
        parent.viewfinder.addAll([
          MoveEffect.to(
            Vector2(0, MainGame.gameMap.overviewGameVisibleSize2.y * 0.5),
            LinearEffectController(1),
          ),
          AnchorEffect.to(Anchor.bottomCenter, LinearEffectController(1))
        ]);
        break;
      case CardEvent.zoomCardsOut:
        parent.add(CameraZoomEffectTo(
          MainGame.gameMap.overviewGameVisibleSize,
          LinearEffectController(0.5),
        ));
        parent.viewfinder.addAll([
          MoveEffect.to(
            Vector2(0, MainGame.gameMap.overviewGameVisibleSize.y * 0.5),
            LinearEffectController(0.5),
          ),
          AnchorEffect.to(Anchor.bottomCenter, LinearEffectController(0.5))
        ]);
        break;
      default:
    }
  }
}
