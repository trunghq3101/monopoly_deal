import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/components/card/behavior_pick_up.dart';
import 'package:monopoly_deal/game/game.dart';

class MainGame2 extends FlameGame
    with HasHoverableComponents, HasTappableComponents {
  static GameMap gameMap = GameMap();
  static GameAsset gameAsset = GameAsset();
  static var cardTotalAmount = 100;

  World get _world => children.query<World>().first;
  CardDeckPublisher get _cardDeckPublisher =>
      children.query<CardDeckPublisher>().first;
  late SelectToDeal _selectToDeal;

  @override
  Future<void>? onLoad() async {
    await gameAsset.load();

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
        final cards =
            List.generate(cardTotalAmount, (int index) => Card(cardId: index))
              ..shuffle();
        for (var i = 0; i < cardTotalAmount; i++) {
          _setupCard(cards[i], i);
        }
        _world.addAll(cards);
      }
    }
  }

  void _setupCard(Card card, int index) {
    final cardStateMachine = CardStateMachine();
    final addToDeckBehavior = AddToDeckBehavior(index: index, priority: index);
    final dealToPlayerBehavior = DealToPlayerBehavior();
    final pickUpBehavior = PickUpBehavior();
    card.add(cardStateMachine);
    card.add(addToDeckBehavior);
    card.add(dealToPlayerBehavior);
    card.add(pickUpBehavior);
    _cardDeckPublisher.addSubscriber(addToDeckBehavior);
    addToDeckBehavior.addSubscriber(_cardDeckPublisher);
    _selectToDeal.addSubscriber(cardStateMachine);
    cardStateMachine.addSubscriber(dealToPlayerBehavior);
    cardStateMachine.addSubscriber(pickUpBehavior);
  }
}

mixin HasWorldRef on HasGameReference<FlameGame> {
  World get world => game.children.query<World>().first;
}
