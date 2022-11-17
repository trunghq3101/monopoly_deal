import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';

class MainGame extends BaseGame {
  @override
  World get world => _world;
  final World _world = World();

  @override
  CameraComponent get cameraComponent => _cameraComponent;
  late final CameraComponent _cameraComponent;

  @override
  Future<void> onLoad() async {
    await gameAssets.preCache();
    final milestones = Milestones();
    const randSeed = 1;
    const deckCapacity = 100;
    final cardSize = Vector2(300, 440);

    world.addToParent(this);
    _cameraComponent = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2.all(600)
      ..addToParent(this);

    final gameMasterBroadcaster = GameMasterBroadcaster(null);

    GameMaster(
      cardsGenerator: CardsGenerator(
        randSeed: randSeed,
        deckCapacity: deckCapacity,
        cardSize: cardSize,
        cardAnchor: Anchor.center,
      ),
      milestones: milestones,
      broadcaster: gameMasterBroadcaster,
    ).addToParent(this);

    CameraMan(gameMasterBroadcaster: gameMasterBroadcaster).addToParent(this);
  }
}
