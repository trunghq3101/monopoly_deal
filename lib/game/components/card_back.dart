import 'package:flame/components.dart';
import 'package:monopoly_deal/game/configurations/game_assets.dart';

class CardBack extends SpriteComponent {
  CardBack({required this.id});

  final int id;

  @override
  Future<void>? onLoad() async {
    sprite = gameAssets.sprites['card'];
  }
}
