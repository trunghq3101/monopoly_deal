import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';

class Card extends PositionComponent
    with HasGameReference<FlameGame>, HasGameMapRef {
  @override
  Future<void>? onLoad() async {
    anchor = Anchor.bottomRight;
    size = gameMap.cardSize;
    final img = Flame.images.fromCache('card.png');
    final spriteComponent = SpriteComponent.fromImage(img);
    spriteComponent.size = size;
    add(spriteComponent);
  }
}
