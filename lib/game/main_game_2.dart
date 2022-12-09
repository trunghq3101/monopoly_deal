import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';

class MainGame2 extends FlameGame {
  static GameMap gameMap = GameMap();

  late World world;
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

    cardDeckPublisher = CardDeckPublisher();
    await add(cardDeckPublisher);

    const cardTotalAmount = 110;
    final cards = List.generate(cardTotalAmount, _setupCard);
    world.addAll(cards);
  }

  Card _setupCard(int index) {
    final card = Card();
    final addToDeckBehavior = AddToDeckBehavior(index: index, priority: index);
    cardDeckPublisher.addSubscriber(addToDeckBehavior);
    card.add(addToDeckBehavior);
    return card;
  }
}
