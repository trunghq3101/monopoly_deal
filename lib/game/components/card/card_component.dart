import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:monopoly_deal/game/game.dart';

class Card extends PositionComponent {
  @override
  Future<void>? onLoad() async {
    anchor = Anchor.bottomRight;
    size = MainGame2.gameMap.cardSize;
    final img = Flame.images.fromCache('card.png');
    final spriteComponent = SpriteComponent.fromImage(img);
    spriteComponent.size = size;
    add(spriteComponent);
  }
}
