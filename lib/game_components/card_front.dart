import 'package:flame/components.dart';

class CardFront extends SpriteComponent {
  CardFront({
    required this.id,
    super.sprite,
    super.position,
    super.size,
  }) : super(anchor: Anchor.center);

  final int id;

  @override
  operator ==(other) => other is CardFront && other.id == id;

  @override
  int get hashCode => id;
}
