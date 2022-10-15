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
        143,
        (index) => Card(
              svg: svg,
              position: size / 2 +
                  (index < 10
                      ? (Vector2.all(3) * index.toDouble())
                      : Vector2.all(0)),
              priority: 142 - index,
            ));
    addAll(cards);
  }
}
