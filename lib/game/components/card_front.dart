import 'package:flame/components.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';

class CardFront extends SpriteComponent {
  CardFront({required this.id});

  final int id;

  @override
  Future<void>? onLoad() async {
    sprite = gameAssets.cardSprites[id];
  }
}
