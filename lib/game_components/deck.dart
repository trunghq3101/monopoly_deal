import 'package:flame/components.dart';

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
    children.register<Card>();
    final sprite = await Sprite.load('card.png');
    final cards = List.generate(
        300,
        (index) => Card(
              sprite: sprite,
              position: size / 2 +
                  (index < 10
                      ? (Vector2.all(3) * index.toDouble())
                      : Vector2.all(0)),
              priority: 299 - index,
            ));
    addAll(cards);
  }
}
