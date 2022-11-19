import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';

class MainGame extends BaseGame with HasTappableComponents, HasHoverables {
  @override
  World get world => _world;
  final World _world = World();

  @override
  CameraComponent get cameraComponent => _cameraComponent;
  late final CameraComponent _cameraComponent;

  @override
  ValueNotifier<TapDownEvent?> get onTapDownBroadcaster =>
      _onTapDownBroadcaster;
  final ValueNotifier<TapDownEvent?> _onTapDownBroadcaster =
      ValueNotifier(null);

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

  @override
  void onTapDown(TapDownEvent event) {
    _onTapDownBroadcaster.value = event;
    super.onTapDown(event);
  }
}
