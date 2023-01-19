import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';

class SetCounter extends PositionComponent {
  SetCounter(this.fullSetAmount);

  final int fullSetAmount;
  int _playedAmount = -1;

  @override
  Future<void>? onLoad() {
    size = Vector2(MainGame.gameMap.cardSize.x, 80);
    anchor = Anchor.topCenter;
    show();
    return null;
  }

  void show() {
    final slotWidth = size.x / fullSetAmount - 20;
    final slots = List.generate(fullSetAmount, (index) {
      return RectangleComponent(
        position: Vector2(10 + index * 20 + index * slotWidth, 0),
        anchor: Anchor.topLeft,
        size: Vector2(slotWidth, 40),
        paint: Paint()..color = const Color.fromARGB(34, 0, 0, 0),
      );
    });
    addAll(slots);
  }

  void newPlayedCard() {
    _playedAmount++;
    final placeholder =
        children.query<RectangleComponent>().elementAt(_playedAmount);
    add(
      RectangleComponent(
        position: placeholder.position,
        anchor: placeholder.anchor,
        size: placeholder.size,
        paint: Paint()..color = const Color.fromARGB(255, 118, 255, 129),
      ),
    );
  }
}
