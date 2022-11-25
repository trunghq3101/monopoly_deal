import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';

class MainGame extends BaseGame
    with HasTappableComponents, HasHoverableComponents {
  @override
  World get world => _world;
  final World _world = World();

  @override
  CameraComponent get cameraComponent => _cameraComponent;
  late final CameraComponent _cameraComponent;

  @override
  Future<void> onLoad() async {
    debugMode = true;
    await gameAssets.preCache();
    final milestones = Milestones();
    const randSeed = 1;
    const deckCapacity = 100;

    world.addToParent(this);
    _cameraComponent = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = GameSize.visibleInitial.size
      ..addToParent(this);

    final gameMasterBroadcaster = GameMasterBroadcaster(null);
    final playerBroadcaster = PlayerBroadcaster();

    GameMaster(
      deck: Deck(
        randSeed: randSeed,
        deckCapacity: deckCapacity,
        cardSize: GameSize.cardOnTable.size,
        cardAnchor: Anchor.center,
      ),
      milestones: milestones,
      broadcaster: gameMasterBroadcaster,
      playerBroadcaster: playerBroadcaster,
    ).addToParent(this);

    CameraMan(gameMasterBroadcaster: gameMasterBroadcaster).addToParent(this);

    Player(broadcaster: playerBroadcaster).addToParent(this);

    world.children.register<CardFront>();
  }
}
