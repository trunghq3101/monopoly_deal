import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class GamePage extends Component with HasGameReference<FlameGame> {
  GamePage({this.isFake = false, RoomGateway? roomGateway})
      : _roomGateway = roomGateway ?? RoomGateway();

  final bool isFake;
  final RoomGateway _roomGateway;

  World get _world => children.query<World>().first;
  CardDeckPublisher get _cardDeckPublisher =>
      children.query<CardDeckPublisher>().first;
  late SelectToDeal _selectToDeal;
  late SelectToPickUp _selectToPickUp;
  late SelectToPickUpForOpponent _selectToPickUpForOpponent;
  late SelectToPreviewing _selectToPreviewing;
  late SelectToReArrange _selectToReArrange;
  late HandToggleButton _handToggleButton;
  late PlaceCardButton _placeCardButton;
  late PassTurnButton _passTurnButton;
  late GameMaster _gameMaster;
  late ZoomOverviewBehavior _zoomOverviewBehavior;

  @override
  Future<void>? onLoad() async {
    final world = World();
    final cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.visibleGameSize =
        MainGame.gameMap.intialGameVisibleSize;
    cameraComponent.viewfinder.position = MainGame.gameMap.deckCenter;

    final cardDeckPublisher = CardDeckPublisher();
    final cardTracker = CardTracker();
    _selectToDeal =
        SelectToDeal(cardTracker: cardTracker, roomGateway: _roomGateway);
    _selectToPickUp =
        SelectToPickUp(cardTracker: cardTracker, roomGateway: _roomGateway);
    _selectToPickUpForOpponent = SelectToPickUpForOpponent(
        cardTracker: cardTracker, roomGateway: _roomGateway);
    _selectToPreviewing =
        SelectToPreviewing(cardTracker: cardTracker, roomGateway: _roomGateway);
    _selectToReArrange = SelectToReArrange(cardTracker: cardTracker);
    _gameMaster = GameMaster(_roomGateway);

    add(world);
    add(cameraComponent);
    add(cardDeckPublisher);
    add(cardTracker);
    add(_selectToReArrange);
    add(_selectToPickUp);
    add(_gameMaster);
    world.add(PlayArea(isOpponent: false)
      ..position = MainGame.gameMap.deckCenter.scaled(2.5));
    for (var i = 0; i < (_roomGateway.playerAmount ?? 2) - 1; i++) {
      world.add(PlayArea()
        ..position = MainGame.gameMap.playAreaPositionForOpponent(i));
    }

    _handToggleButton = HandToggleButton()
      ..position =
          Vector2(MainGame.gameMap.overviewGameVisibleSize.x * 0.5, 2200);
    _placeCardButton = PlaceCardButton()
      ..position = Vector2(0, MainGame.gameMap.cardSizeInHand.y * 1.5 / 2)
      ..addSubscriber(_handToggleButton)
      ..addSubscriber(_selectToReArrange);
    _passTurnButton = PassTurnButton()
      ..position =
          Vector2(MainGame.gameMap.overviewGameVisibleSize.x * -0.5, 2200);
    world
      ..add(_handToggleButton)
      ..add(_placeCardButton)
      ..add(_passTurnButton);

    _zoomOverviewBehavior = ZoomOverviewBehavior();
    cameraComponent.add(_zoomOverviewBehavior);
    _selectToPickUp
      ..addSubscriber(_zoomOverviewBehavior)
      ..addSubscriber(_handToggleButton);

    cardDeckPublisher
      ..addSubscriber(_selectToDeal)
      ..addSubscriber(_zoomOverviewBehavior);

    _selectToDeal.addSubscriber(_gameMaster);

    _gameMaster.addGameEventSubscription(
      _roomGateway.gameEvents.listen((event) async {
        if (event.event == PacketType.turnPassed && _roomGateway.isMyTurn) {
          _gameMaster.takeTurn();
        }
        _selectToPickUpForOpponent
            .onNewEvent(Event(event.event)..payload = event.data);
        _selectToDeal.onNewEvent(Event(event.event)..payload = event.data);
        _placeCardButton.onNewEvent(Event(event.event)..payload = event.data);
        _passTurnButton.onNewEvent(Event(event.event)..payload = event.data);

        if (event.event == PacketType.turnPassed && _roomGateway.isMyTurn) {
          await game.children
              .query<RouterComponent>()
              .first
              .pushAndWait(YourTurnRoute());
          _selectToPickUp.onNewEvent(Event(event.event)..payload = event.data);
        }
      })
        ..pause(),
    );
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    if (type == ChildrenChangeType.added) {
      if (child is CardDeckPublisher) {
        final cards = List.generate(
                MainGame.cardTotalAmount, (int index) => Card(cardIndex: index))
            .reversed
            .toList();
        for (var i = 0; i < MainGame.cardTotalAmount; i++) {
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
    final pickUpForOpponentBehavior = PickUpForOpponentBehavior();
    final pullUpDownBehavior = PullUpDownBehavior();
    final togglePreviewingBehavior = TogglePreviewingBehavior();
    final togglePreviewingForOpponentBehavior =
        TogglePreviewingForOpponentBehavior();
    final toTableBehavior = ToTableBehavior();
    final toTableForOpponentBehavior = ToTableForOpponentBehavior();
    final repositionInHand = RepositionInHandBehavior();
    final revealCardBehavior = RevealCardBehavior();
    card
      ..add(cardStateMachine)
      ..add(addToDeckBehavior)
      ..add(dealToPlayerBehavior)
      ..add(pickUpBehavior)
      ..add(pickUpForOpponentBehavior)
      ..add(pullUpDownBehavior)
      ..add(togglePreviewingBehavior)
      ..add(togglePreviewingForOpponentBehavior)
      ..add(toTableBehavior)
      ..add(toTableForOpponentBehavior)
      ..add(repositionInHand)
      ..add(revealCardBehavior);

    addToDeckBehavior.addSubscriber(_cardDeckPublisher);
    dealToPlayerBehavior
      ..addSubscriber(cardStateMachine)
      ..addSubscriber(_gameMaster);
    pickUpBehavior.addSubscriber(cardStateMachine);
    pickUpForOpponentBehavior.addSubscriber(cardStateMachine);
    togglePreviewingBehavior.addSubscriber(cardStateMachine);
    _cardDeckPublisher.addSubscriber(addToDeckBehavior);
    _selectToDeal.addSubscriber(cardStateMachine);
    _selectToPickUp.addSubscriber(cardStateMachine);
    _selectToPreviewing.addSubscriber(cardStateMachine);
    _handToggleButton.addSubscriber(cardStateMachine);
    _placeCardButton.addSubscriber(cardStateMachine);
    _selectToReArrange.addSubscriber(cardStateMachine);
    _gameMaster.addGameEventSubscription(
      _roomGateway.gameEvents.listen((event) {
        if (event.event == PacketType.cardRevealed) {
          final data = event.data as CardRevealed;
          MainGame.gameAsset.onCardRevealed(data.cardIndex, data.cardId);
          revealCardBehavior.onNewEvent(
            Event(event.event)..payload = data,
          );
        }
        togglePreviewingForOpponentBehavior
            .onNewEvent(Event(event.event)..payload = event.data);
        toTableForOpponentBehavior
            .onNewEvent(Event(event.event)..payload = event.data);
      })
        ..pause(),
    );

    cardStateMachine
      ..addSubscriber(dealToPlayerBehavior)
      ..addSubscriber(pickUpBehavior)
      ..addSubscriber(_selectToPickUp)
      ..addSubscriber(_selectToPreviewing)
      ..addSubscriber(pullUpDownBehavior)
      ..addSubscriber(_handToggleButton)
      ..addSubscriber(togglePreviewingBehavior)
      ..addSubscriber(_placeCardButton)
      ..addSubscriber(toTableBehavior)
      ..addSubscriber(repositionInHand)
      ..addSubscriber(_passTurnButton);
    _selectToPickUpForOpponent.addSubscriber(pickUpForOpponentBehavior);
  }
}

mixin HasGamePage on HasGameReference<FlameGame> {
  World get world => game.children
      .query<RouterComponent>()
      .first
      .routes['/']!
      .children
      .query<GamePage>()
      .first
      .children
      .query<World>()
      .first;

  GameMaster get gameMaster => game.children
      .query<RouterComponent>()
      .first
      .routes['/']!
      .children
      .query<GamePage>()
      .first
      .children
      .query<GameMaster>()
      .first;

  GamePage get gamePage => game.children
      .query<RouterComponent>()
      .first
      .routes['/']!
      .children
      .query<GamePage>()
      .first;
}
