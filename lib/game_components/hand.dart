import 'package:flame/components.dart';
import 'package:monopoly_deal/game_components/card.dart';

class Hand extends PositionComponent {
  Hand({
    super.position,
    super.size,
  }) : super(anchor: Anchor.topCenter);

  @override
  void onMount() {
    addAll(List.generate(
      5,
      (index) => Card(
        id: index,
        position: Vector2((index - 3) * 100, 0),
        priority: index,
        size: Vector2(Card.kCardWidth * size.y / Card.kCardHeight, size.y),
      ),
    ));
  }
}
