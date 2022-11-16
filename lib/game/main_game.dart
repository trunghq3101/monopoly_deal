import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';

class MainGame extends BaseGame {
  @override
  World get world => _world;

  final World _world = World();

  @override
  Future<void> onLoad() async {
    await gameAssets.preCache();
    add(world);
    add(CameraComponent(world: world));
    add(GameMaster(
      cardsGenerator: CardsGenerator(randSeed: 1, deckSize: 100),
      milestones: Milestones(),
    ));
  }
}
