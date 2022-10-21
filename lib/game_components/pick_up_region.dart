import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game_components/card.dart';
import 'package:monopoly_deal/game_components/main_game.dart';

class PickUpRegion extends PositionComponent
    with HasGameReference<MainGame>, TapCallbacks {
  PickUpRegion({super.position})
      : super(
          size: Card.kCardSize * 1.5,
          anchor: Anchor.center,
        );

  @override
  void onTapDown(TapDownEvent event) {
    game.pickUp = true;
  }
}
