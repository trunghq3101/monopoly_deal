import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:monopoly_deal/game/game.dart';

class Card extends PositionComponent with HasCardIndex, HasCardState {
  Card({int cardIndex = 0}) : _cardIndex = cardIndex;

  final int _cardIndex;

  @override
  int get cardIndex => _cardIndex;

  @override
  CardState get state => children.query<CardStateMachine>().first.state;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    size = MainGame.gameMap.cardSize;
    final img = Flame.images.fromCache('card.png');
    final spriteComponent = SpriteComponent.fromImage(img);
    spriteComponent.size = size;
    add(spriteComponent);
  }
}

mixin HasCardIndex {
  int get cardIndex;
}

mixin HasCardState {
  CardState get state;
}
