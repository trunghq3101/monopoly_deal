import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';

class MainGame2 extends FlameGame {
  late World world;
  late CardDeckPublisher cardDeckPublisher;
  late GameMap gameMap;

  @override
  Future<void>? onLoad() async {
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
    await Flame.images.load('card.png');

    cardDeckPublisher = CardDeckPublisher();
    await add(cardDeckPublisher);

    const cardTotalAmount = 110;
    final cards = List.generate(cardTotalAmount, setupCard);
    await world.addAll(cards);
  }

  Card setupCard(int index) {
    final card = Card(Flame.images.fromCache('card.png'))
      ..size = gameMap.cardSize;
    final addToDeckBehavior = AddToDeckBehavior(index: index, priority: index);
    cardDeckPublisher.addSubscriber(addToDeckBehavior);
    card.add(addToDeckBehavior);
    return card;
  }
}
