import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';

class MainGame2 extends FlameGame with HasHoverableComponents {
  static GameMap gameMap = GameMap();
  static var cardTotalAmount = 110;

  World get _world => children.query<World>().first;
  CardDeckPublisher get _cardDeckPublisher =>
      children.query<CardDeckPublisher>().first;
  late SelectToDeal _selectToDeal;

  @override
  Future<void>? onLoad() async {
    await Flame.images.loadAll(['card.png']);

    gameMap = GameMap(
        deckCenter: Vector2.zero(),
        deckSpacing: 0.7,
        cardSize: Vector2(300, 440),
        playerPositions: [Vector2(0, 1000), Vector2(0, -1000)]);

    final world = World();
    final cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.visibleGameSize = gameMap.intialGameVisibleSize;

    final cardDeckPublisher = CardDeckPublisher();
    final cardTracker = CardTracker();
    _selectToDeal = SelectToDeal(cardTracker: cardTracker);

    add(world);
    add(cameraComponent);
    add(cardDeckPublisher);
    add(cardTracker);

    final zoomOverviewBehavior = ZoomOverviewBehavior();
    cameraComponent.add(zoomOverviewBehavior);

    final cardDeckEventToCameraEventAdapter =
        CardDeckEventToCameraEventAdapter();
    cardDeckPublisher
      ..addSubscriber(_selectToDeal)
      ..addSubscriber(cardDeckEventToCameraEventAdapter);
    cardDeckEventToCameraEventAdapter.addSubscriber(zoomOverviewBehavior);
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    if (type == ChildrenChangeType.added) {
      if (child is CardDeckPublisher) {
        final cards = List.generate(cardTotalAmount, _setupCard);
        _world.addAll(cards);
      }
    }
  }

  Card _setupCard(int index) {
    final card = Card(cardId: index);
    final cardStateMachine = CardStateMachine();
    final addToDeckBehavior = AddToDeckBehavior(index: index, priority: index);
    final dealToPlayerBehavior = DealToPlayerBehavior();
    card.add(cardStateMachine);
    card.add(addToDeckBehavior);
    card.add(dealToPlayerBehavior);
    _cardDeckPublisher.addSubscriber(addToDeckBehavior);
    addToDeckBehavior.addSubscriber(_cardDeckPublisher);
    _selectToDeal.addSubscriber(cardStateMachine);
    cardStateMachine.addSubscriber(dealToPlayerBehavior);
    return card;
  }
}

mixin HasWorldRef on HasGameReference<FlameGame> {
  World get world => game.children.query<World>().first;
}
