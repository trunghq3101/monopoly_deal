import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/components/card/behavior_pick_up.dart';
import 'package:monopoly_deal/game/components/card/behavior_pull_up_down.dart';
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
  late SelectToPickUp _selectToPickUp;
  late HandToggleButton _handToggleButton;

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
    _selectToPickUp = SelectToPickUp(cardTracker: cardTracker);

    add(world);
    add(cameraComponent);
    add(cardDeckPublisher);
    add(cardTracker);

    _handToggleButton = HandToggleButton()
      ..position =
          Vector2(MainGame2.gameMap.overviewGameVisibleSize.x * 0.5, 400);
    // final endTurnBtn = ButtonComponent(text: "End turn")
    //   ..position =
    //       Vector2(MainGame2.gameMap.overviewGameVisibleSize.x * 0.5, 200);
    world.add(_handToggleButton);
    // world.add(endTurnBtn);

    final zoomOverviewBehavior = ZoomOverviewBehavior();
    cameraComponent.add(zoomOverviewBehavior);

    cardDeckPublisher
      ..addSubscriber(_selectToDeal)
      ..addSubscriber(zoomOverviewBehavior);
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
    final pullUpDownBehavior = PullUpDownBehavior();
    final togglePreviewing = TogglePreviewingBehavior();
    card
      ..add(cardStateMachine)
      ..add(addToDeckBehavior)
      ..add(dealToPlayerBehavior)
      ..add(pickUpBehavior)
      ..add(pullUpDownBehavior)
      ..add(togglePreviewing);

    _cardDeckPublisher.addSubscriber(addToDeckBehavior);
    addToDeckBehavior.addSubscriber(_cardDeckPublisher);
    _selectToDeal.addSubscriber(cardStateMachine);
    _selectToPickUp.addSubscriber(cardStateMachine);
    _handToggleButton.addSubscriber(cardStateMachine);
    cardStateMachine
      ..addSubscriber(dealToPlayerBehavior)
      ..addSubscriber(pickUpBehavior)
      ..addSubscriber(_selectToPickUp)
      ..addSubscriber(pullUpDownBehavior)
      ..addSubscriber(_handToggleButton)
      ..addSubscriber(togglePreviewing);
  }
}

mixin HasWorldRef on HasGameReference<FlameGame> {
  World get world => game.children.query<World>().first;
}
