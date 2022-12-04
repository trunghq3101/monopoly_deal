import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:monopoly_deal/game/game.dart';

class MainGameV2 extends BaseGame {
  late final Image cardImg;

  @override
  World get world => _world;
  final World _world = World();

  @override
  CameraComponent get cameraComponent => _cameraComponent;
  late final CameraComponent _cameraComponent;

  @override
  Future<void>? onLoad() async {
    await Flame.images.load('card.png');

    world.addToParent(this);
    _cameraComponent = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = GameSize.visibleInitial.size
      ..addToParent(this);

    final deck = Deck(config: DeckConfig.game());
    deck
      ..amountNotifier.addListener(() => addCardsToWorld(deck, world))
      ..addToParent(this);
  }
}

void addCardsToWorld(Deck deck, World world) {
  for (var p in deck.newCards) {
    world.add(
      SpriteComponent.fromImage(
        Flame.images.fromCache('card.png'),
        size: Vector2(300, 440),
        position: p,
        anchor: Anchor.center,
      ),
    );
  }
}
