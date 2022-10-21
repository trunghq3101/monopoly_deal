import 'package:flame/components.dart';
import 'package:monopoly_deal/game_components/card.dart';

class Hand extends PositionComponent {
  Hand({
    super.position,
    super.size,
  }) : super(anchor: Anchor.center);

  @override
  void onMount() {
    addAll(List.generate(
      5,
      (index) => Card(
        id: index,
        position: Vector2(index * 400, 0),
        priority: 0,
        size: Card.kCardSize * 5,
      ),
    ));
  }
}
