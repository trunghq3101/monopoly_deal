import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:monopoly_deal/game/game.dart';

class Card extends PositionComponent with HasCardId, HasCardState {
  Card({int cardId = 0}) : _cardId = cardId;

  final int _cardId;

  @override
  int get cardId => _cardId;

  @override
  CardState get state => children.query<CardStateMachine>().first.state;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    size = MainGame2.gameMap.cardSize;
    final img = Flame.images.fromCache('card.png');
    final spriteComponent = SpriteComponent.fromImage(img);
    spriteComponent.size = size;
    add(spriteComponent);
  }
}

mixin HasCardId {
  int get cardId;
}

mixin HasCardState {
  CardState get state;
}
