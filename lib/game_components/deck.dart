import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

import 'card.dart';

class Deck extends PositionComponent {
  Deck()
      : super(
          position: Vector2(0, 0),
          size: Card.kCardSize,
          anchor: Anchor.center,
        );

  @override
  Future<void>? onLoad() async {
    final svg = await Svg.load('card.svg');
    children.register<Card>();
    final cards = List.generate(
        110,
        (index) => Card(
              svg: svg,
              position: size / 2 + Vector2.all(1) * index.toDouble(),
              priority: 109 - index,
            ));
    addAll(cards);
  }

  void deal() {
    for (var i = 0; i < 10; i++) {
      children.query<Card>()[i].deal(
          by: Vector2(0, Card.kCardHeight * 2.5 * (i % 2 == 0 ? -1 : 1)),
          delay: (i + 1) * 0.3,
          priority: i);
    }
  }
}
