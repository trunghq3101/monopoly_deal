import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';

class MainGame2 extends FlameGame {
  late World world;
  late GameMap gameMap;
  late CardDeckPublisher cardDeckPublisher;

  @override
  Future<void>? onLoad() async {
    await Flame.images.loadAll(['card.png']);

    world = World();
    await add(world);
    final cameraComponent = CameraComponent(world: world);
    await add(cameraComponent);
    gameMap = GameMap(
      deckBottomRight: Vector2(300, 440) * 0.5,
      deckSpacing: 0.7,
      cardSize: Vector2(300, 440),
    );
    await add(gameMap);

    cardDeckPublisher = CardDeckPublisher();
    await add(cardDeckPublisher);
  }

  @override
  void onChildrenChanged(child, type) {
    if (child is GameMap && type == ChildrenChangeType.added) {
      const cardTotalAmount = 110;
      final cards = List.generate(cardTotalAmount, _setupCard);
      world.addAll(cards);
    }
  }

  Card _setupCard(int index) {
    final card = Card();
    final addToDeckBehavior = AddToDeckBehavior(index: index, priority: index);
    cardDeckPublisher.addSubscriber(addToDeckBehavior);
    card.add(addToDeckBehavior);
    return card;
  }
}
