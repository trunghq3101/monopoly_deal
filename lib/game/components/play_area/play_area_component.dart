import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';

class PlayArea extends PositionComponent with HasGameReference<FlameGame> {
  PlayArea({this.isOpponent = true});

  final bool isOpponent;

  @override
  Future<void>? onLoad() {
    anchor = Anchor.topCenter;
    const hSpacing = 40;
    const vSpacing = 80;
    final slotSize = MainGame.gameMap.cardSize + Vector2.all(40);
    size = isOpponent
        ? Vector2(slotSize.x * 2 + hSpacing * 3, slotSize.y * 5 + vSpacing * 6)
        : Vector2(slotSize.x * 5 + hSpacing * 6, slotSize.y * 2 + vSpacing * 3);
    List.generate(10, (index) {
      final factor1 = index % 2 + 0.5;
      final factor2 = ((index / 2).floor() + 0.5);
      final cardPlacePosition = Vector2(
          hSpacing * ((isOpponent ? factor1 : factor2) + 0.5) +
              slotSize.x * (isOpponent ? factor1 : factor2),
          vSpacing * ((isOpponent ? factor2 : factor1) + 0.5) +
              slotSize.y * (isOpponent ? factor2 : factor1));
      final cardPlace = RectangleComponent(
          position: cardPlacePosition,
          anchor: Anchor.center,
          size: slotSize,
          paint: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 20
            ..color = const Color.fromARGB(17, 0, 0, 0));
      final counter = SetCounter(GameAsset.setAmountOfCardType[index])
        ..position = cardPlacePosition + Vector2(0, slotSize.y * 0.5 + 20);
      add(cardPlace);
      add(counter);
    });
    return null;
  }
}
