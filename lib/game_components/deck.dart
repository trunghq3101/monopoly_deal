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
        20,
        (index) => Card(
              svg: svg,
              position: size / 2 + Vector2.all(5) * index.toDouble(),
              priority: 19 - index,
            ));
    addAll(cards);
  }
}
