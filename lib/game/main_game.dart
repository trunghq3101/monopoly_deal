import 'package:flame/components.dart';
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
    final milestones = Milestones();
    const randSeed = 1;
    const deckCapacity = 100;
    final cardSize = Vector2(300, 440);

    world.addToParent(this);
    CameraComponent(world: world).addToParent(this);

    GameMaster(
      cardsGenerator: CardsGenerator(
        randSeed: randSeed,
        deckCapacity: deckCapacity,
        cardSize: cardSize,
        cardAnchor: Anchor.center,
      ),
      milestones: milestones,
    ).addToParent(this);
  }
}
