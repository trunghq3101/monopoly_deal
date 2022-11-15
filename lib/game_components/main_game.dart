import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/input.dart';
import 'package:monopoly_deal/features/cards/hand.dart';
import 'package:simple_state_machine/simple_state_machine.dart';
import 'package:tiled/tiled.dart';

import '../features/cards/card.dart';
import '../features/cards/deck.dart';
import '../features/controls/pause_button.dart';
import '../features/map/deal_target.dart';
import '../features/map/playground_map.dart';
import 'game_assets.dart';
import 'main_game_states.dart';
import 'tappable_overlay.dart';

class MainGame extends FlameGame
    with HasTappableComponents, HasStateMachine, MouseMovementDetector {
  MainGame();

  late final World world;
  late final CameraComponent cameraComponent;
  late final Viewfinder viewfinder;
  late final Viewport viewport;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;

  // @override
  // Color backgroundColor() => const Color(0xFFD74E30);

  @override
  Future<void>? onLoad() async {
    debugMode = true;
    await gameAssets.preCache();
    add(FpsTextComponent(position: Vector2(0, size.y - 24)));

    world = World();
    cameraComponent = CameraComponent(world: world);
    viewport = cameraComponent.viewport;
    viewfinder = cameraComponent.viewfinder;
    viewfinder.visibleGameSize = Card.kCardSize * 1.2;

    children
      ..register<World>()
      ..register<CameraComponent>();
    world.children
      ..register<Deck>()
      ..register<DealTarget>()
      ..register<Hand>();

    await addAll([world, cameraComponent, TappableOverlay(), PauseButton()]);

    newMachine({
      CameraState.initial: {
        Command(Deck.kDeal):
            DealCameraTransition(CameraState.initial, cameraComponent),
      }
    });
    newMachine({
      MainGameState.initial: {
        Command(kMouseMove):
            CardTargetingTransition(MainGameState.initial, this),
      }
    });

    world.add(PlaygroundMap(
      'two_players.tmx',
      {
        'playground': (r, _, __) {
          playgroundSize = Vector2(r.width, r.height);
          world.add(PositionComponent(
              position: Vector2(r.x, r.y), size: playgroundSize));
        },
        'hand': (r, _, __) => world.add(
              Hand()
                ..position = Vector2(r.x, r.y)
                ..size = Vector2(r.width, r.height),
            ),
        'deck': (r, _, __) => world.add(
              Deck(
                cardSprite: gameAssets.sprites['card']!,
                position: Vector2(r.x, r.y),
              ),
            ),
        'deal_region_0': (r, _, __) => world.add(
              PickUpRegion(
                position: Vector2(r.x, r.y),
                size: Vector2(r.width, r.height),
                anchor: Anchor.center,
              ),
            ),
        'deal_region_1': (r, _, __) => world.add(
              DealTarget(
                position: Vector2(r.x, r.y),
                size: Vector2(r.width, r.height),
                anchor: Anchor.center,
              ),
            ),
        'play_region_0': (r, tiledMap, name) async {
          final slots = tiledMap.getLayer<ObjectGroup>(r.name)!;
          for (var s in slots.objects) {
            world.add(PositionComponent(
              position: Vector2(s.x, s.y),
              size: Vector2(
                (await s.template!)!.object!.width,
                (await s.template!)!.object!.height,
              ),
              anchor: Anchor.center,
            ));
          }
        },
        'play_region_1': (r, tiledMap, name) async {
          final slots = tiledMap.getLayer<ObjectGroup>(r.name)!;
          for (var s in slots.objects) {
            world.add(PositionComponent(
              position: Vector2(s.x, s.y),
              size: Vector2(
                (await s.template!)!.object!.width,
                (await s.template!)!.object!.height,
              ),
              anchor: Anchor.center,
            ));
          }
        }
      },
    ));
  }

  @override
  void onMount() {
    super.onMount();
    addAll([
      TimerComponent(
          period: 0.1,
          removeOnFinish: true,
          onTick: () {
            world.children.query<Deck>().first.onCommand(Command(Deck.kBuild));
          }),
      TimerComponent(
          period: 1.8,
          removeOnFinish: true,
          onTick: () {
            onCommand(Command(Deck.kDeal));
            world.children.query<Deck>().first.onCommand(
                Command(Deck.kDeal, world.children.query<DealTarget>()));
          })
    ]);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    onCommand(Command(kMouseMove, info));
  }
}
