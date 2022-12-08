import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

class Card extends PositionComponent with HasGameReference<FlameGame> {
  Card(this.img);

  final Image img;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.bottomRight;
    final spriteComponent = SpriteComponent.fromImage(img);
    spriteComponent.size = size;
    add(spriteComponent);
  }
}
