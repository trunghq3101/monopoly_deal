import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:monopoly_deal/models/game_model.dart';

import 'game_components/card.dart';
import 'game_components/deck.dart';
import 'game_components/game_assets.dart';
import 'game_components/pause_button.dart';

class MainGame extends FlameGame with HasTappables {
  MainGame(this.gameModel);

  final GameModel gameModel;

  @override
  Color backgroundColor() => const Color(0xFFD74E30);

  @override
  Future<void>? onLoad() async {
    await gameAssets.preCache();
    final pauseButton = PauseButton();
    final world = World();
    final deck = Deck();
    final camera = CameraComponent(world: world);
    camera.viewfinder.visibleGameSize = Card.kCardSize * 1.2;

    children
      ..register<World>()
      ..register<CameraComponent>();
    camera.viewport.children.register<PauseButton>();
    world.children.register<Deck>();
    await addAll([world, camera]);
    await world.add(deck);
    await camera.viewport.add(pauseButton);

    camera.follow(deck);
  }
}
