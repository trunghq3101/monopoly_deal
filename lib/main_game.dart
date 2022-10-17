import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:monopoly_deal/models/game_model.dart';

import 'game_components/card.dart';
import 'game_components/deck.dart';
import 'game_components/effects/visible_game_size_effect.dart';
import 'game_components/game_assets.dart';
import 'game_components/pause_button.dart';

class MainGame extends FlameGame with HasTappables {
  MainGame(this.gameModel);

  final GameModel gameModel;
  late final CameraComponent _cameraComponent;
  Viewfinder get viewfinder => _cameraComponent.viewfinder;
  World get world => _cameraComponent.world;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;

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
