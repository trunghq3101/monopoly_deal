import 'package:flame/components.dart';

class Card extends SpriteComponent {
  Card({
    required this.id,
    super.sprite,
    super.position,
    super.priority,
  }) : super(anchor: Anchor.center);

  static const kCardWidth = 280.0;
  static const kCardHeight = 395.0;
  static final kCardSize = Vector2(kCardWidth, kCardHeight);

  final int id;
}
