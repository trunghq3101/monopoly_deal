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
    final card = Card(svg: await Svg.load('card.svg'), position: size / 2);
    children.register<Card>();
    add(card);
  }
}
