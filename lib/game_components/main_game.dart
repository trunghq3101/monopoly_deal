import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:monopoly_deal/game_components/pick_up_region.dart';
import 'package:monopoly_deal/models/game_model.dart';

import 'card.dart';
import 'deck.dart';
import 'game_assets.dart';
import 'hand.dart';
import 'pause_button.dart';

class MainGame extends FlameGame with HasTappableComponents {
  MainGame(this.gameModel);

  final GameModel gameModel;
  late final World world;
  late final CameraComponent cameraComponent;
  late final Viewfinder viewfinder;
  late final Viewport viewport;
  late final Deck deck;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;

  // @override
  // Color backgroundColor() => const Color(0xFFD74E30);

  @override
  Future<void>? onLoad() async {
    await gameAssets.preCache();
    add(FpsTextComponent(position: Vector2(0, size.y - 24)));

    deck = Deck(dealTargets: [
      PickUpRegion(
        size: Card.kCardSize * 1.5,
        position: Vector2(0, Card.kCardHeight * 2.5),
        anchor: Anchor.center,
      ),
      PositionComponent(
        size: Card.kCardSize * 1.5,
        position: Vector2(0, Card.kCardHeight * -2.5),
        anchor: Anchor.center,
      ),
    ]);

    world = World();
    world.children.register<Deck>();
    await world.addAll([deck, ...deck.dealTargets]);

    cameraComponent = CameraComponent(world: world);
    cameraComponent.follow(deck);

    viewport = cameraComponent.viewport;
    viewport.children
      ..register<PauseButton>()
      ..register<Hand>();
    await viewport.addAll([
      PauseButton(),
      Hand(
        size: canvasSize,
        position: canvasSize / 2,
      ),
    ]);

    viewfinder = cameraComponent.viewfinder;
    viewfinder.visibleGameSize = Card.kCardSize * 1.2;

    children
      ..register<World>()
      ..register<CameraComponent>();
    await addAll([world, cameraComponent]);
  }

  @override
  void onMount() {
    super.onMount();
    TimerComponent(
      period: 1.8,
      onTick: () {
        _deal();
      },
      removeOnFinish: true,
    ).addToParent(this);
  }

  void _deal() {
    deck.deal();
  }
}