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
  static const kCardAmount = 110;
  int _currentLoadedCardIndex = 0;

  @override
  Future<void>? onLoad() async {
    final svg = await Svg.load('card.svg');
    children.register<Card>();
    children.register<TimerComponent>();
    final cards = List.generate(
        kCardAmount,
        (index) => Card(
              svg: svg,
              position: size / 2 +
                  Vector2.all(1) * (kCardAmount / 2) -
                  Vector2.all(1) * index.toDouble(),
              priority: index,
            ));
    TimerComponent(
      period: 0.01,
      repeat: true,
      onTick: () async {
        if (_currentLoadedCardIndex < kCardAmount) {
          add(cards[_currentLoadedCardIndex++]);
        }
        if (children.query<Card>().length == kCardAmount) {
          children.query<TimerComponent>().first.removeFromParent();
        }
      },
    ).addToParent(this);
  }

  void deal() {
    for (var i = 0; i < 10; i++) {
      children.query<Card>()[kCardAmount - 1 - i].deal(
          by: Vector2(0, Card.kCardHeight * 2.5 * (i % 2 == 0 ? -1 : 1)),
          delay: (i + 1) * 0.3,
          priority: i);
    }
  }
}
