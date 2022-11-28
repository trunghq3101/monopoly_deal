import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/actors/opponent.dart';
import 'package:monopoly_deal/game/game.dart';

class MainGame extends BaseGame
    with HasTappableComponents, HasHoverableComponents, HasTappablesBridge {
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

    world.addToParent(this);
    _cameraComponent = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = GameSize.visibleInitial.size
      ..addToParent(this);

    GameMaster(
      deck: Deck(
        randSeed: randSeed,
        deckCapacity: deckCapacity,
        cardSize: GameSize.cardOnTable.size,
        cardAnchor: Anchor.center,
      ),
      milestones: milestones,
    ).addToParent(this);
    CameraMan().addToParent(this);
    Player().addToParent(this);
    Opponent().addToParent(this);

    children
      ..register<Player>()
      ..register<CameraMan>()
      ..register<Opponent>();
    world.children.register<CardFront>();
  }
}
