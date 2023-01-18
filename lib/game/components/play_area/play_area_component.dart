import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';

class PlayArea extends PositionComponent {
  PlayArea({this.isOpponent = true});

  final bool isOpponent;
  final _paint = Paint()..color = const Color.fromARGB(255, 249, 231, 118);

  @override
  Future<void>? onLoad() {
    anchor = Anchor.topCenter;
    const spacing = 40;
    final slotSize = MainGame.gameMap.cardSize + Vector2.all(40);
    size = isOpponent
        ? Vector2(slotSize.x * 2 + spacing * 3, slotSize.y * 5 + spacing * 6)
        : Vector2(slotSize.x * 5 + spacing * 6, slotSize.y * 2 + spacing * 3);
    final slots = List.generate(10, (index) {
      final factor1 = index % 2 + 0.5;
      final factor2 = ((index / 2).floor() + 0.5);
      return RectangleComponent(
          position: Vector2(
              spacing * ((isOpponent ? factor1 : factor2) + 0.5) +
                  slotSize.x * (isOpponent ? factor1 : factor2),
              spacing * ((isOpponent ? factor2 : factor1) + 0.5) +
                  slotSize.y * (isOpponent ? factor2 : factor1)),
          anchor: Anchor.center,
          size: slotSize,
          paint: Paint()
            ..style = PaintingStyle.fill
            ..color = const Color.fromARGB(255, 231, 231, 231));
    });
    addAll(slots);
    return null;
  }
}
