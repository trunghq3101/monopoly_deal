import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame_tiled/flame_tiled.dart';
import 'package:monopoly_deal/game_components/card.dart';
import 'package:tiled/tiled.dart';

import '../game_components/game_assets.dart';

class TableLayoutGame extends FlameGame {
  late final World world;
  late final CameraComponent cameraComponent;
  late final Viewfinder viewfinder;
  late final Viewport viewport;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;

  @override
  bool get debugMode => true;

  @override
  Future<void>? onLoad() async {
    await gameAssets.preCache();
    add(FpsTextComponent(position: Vector2(0, size.y - 24)));

    world = World();

    cameraComponent = CameraComponent(world: world);

    viewport = cameraComponent.viewport;

    await viewport.addAll([]);

    viewfinder = cameraComponent.viewfinder;
    viewfinder.visibleGameSize = Vector2.all(3000);

    children
      ..register<World>()
      ..register<CameraComponent>();
    await addAll([world, cameraComponent]);

    final mapComponent =
        await TiledComponent.load('two_players.tmx', Vector2.all(32));
    world.add(mapComponent);

    final regions = mapComponent.tileMap.getLayer<ObjectGroup>('regions')!;
    for (var r in regions.objects) {
      switch (r.name) {
        case 'deck':
          mapComponent.add(Card(
              id: 0,
              position: Vector2(r.x, r.y),
              sprite: await Sprite.load('card.png')));

          break;
        case 'deal_region_0':
        case 'deal_region_1':
          mapComponent.add(PositionComponent(
            position: Vector2(r.x, r.y),
            size: Vector2(r.width, r.height),
            anchor: Anchor.center,
          ));
          break;
        case 'play_region_0':
        case 'play_region_1':
          final slots = mapComponent.tileMap.getLayer<ObjectGroup>(r.name)!;
          for (var s in slots.objects) {
            mapComponent.add(PositionComponent(
              position: Vector2(s.x, s.y),
              size: Vector2(
                (await s.template!)!.object!.width,
                (await s.template!)!.object!.height,
              ),
              anchor: Anchor.center,
            ));
          }
          break;
        default:
      }
    }
  }
}
