import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:monopoly_deal/game_components/deal_region.dart';
import 'package:monopoly_deal/game_components/hand.dart';
import 'package:monopoly_deal/models/game_model.dart';

import 'card.dart';
import 'deck.dart';
import 'effects/visible_game_size_effect.dart';
import 'game_assets.dart';
import 'pause_button.dart';

class MainGame extends FlameGame with HasTappableComponents {
  MainGame(this.gameModel);

  final GameModel gameModel;
  late final CameraComponent _cameraComponent;
  Viewfinder get viewfinder => _cameraComponent.viewfinder;
  World get world => _cameraComponent.world;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;
  bool pickUp = false;

  @override
  Color backgroundColor() => const Color(0xFFD74E30);

  @override
  Future<void>? onLoad() async {
    await gameAssets.preCache();
    final pauseButton = PauseButton();
    final world = World();
    final deck = Deck();
    _cameraComponent = CameraComponent(world: world);
    viewfinder.visibleGameSize = Card.kCardSize * 1.2;

    children
      ..register<World>()
      ..register<CameraComponent>();
    _cameraComponent.viewport.children.register<PauseButton>();
    world.children.register<Deck>();
    await addAll([world, _cameraComponent]);
    await world.add(deck);
    await world.add(PickUpRegion(position: Vector2(0, Card.kCardHeight * 2.5)));
    await world
        .add(PickUpRegion(position: Vector2(0, Card.kCardHeight * -2.5)));
    await _cameraComponent.viewport.add(pauseButton);

    _cameraComponent.follow(deck);
  }

  @override
  void onMount() {
    super.onMount();
    TimerComponent(
      period: 1.5,
      onTick: () {
        _deal();
      },
      removeOnFinish: true,
    ).addToParent(this);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (pickUp) {
      pickUp = false;
      world.children.query<Deck>().first.pickUp();
      TimerComponent(
        period: 1,
        onTick: () {
          world.add(Hand(position: Vector2(0, 1000)));
        },
        removeOnFinish: true,
      ).addToParent(this);
    }
  }

  void _deal() {
    viewfinder.add(
      VisibleGameSizeEffect.to(
        Vector2(Card.kCardWidth * 3, Card.kCardHeight * 7),
        EffectController(
          duration: 1,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
    world.children.query<Deck>().first.deal();
  }
}
