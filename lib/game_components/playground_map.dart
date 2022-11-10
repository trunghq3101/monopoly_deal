import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tiled/tiled.dart';

class PlaygroundMap extends PositionComponent {
  final String fileName;
  final Map<
      String,
      FutureOr<void> Function(
    TiledObject tiledObject,
    RenderableTiledMap tiledMap,
    String name,
  )> renderers;

  PlaygroundMap(this.fileName, this.renderers);

  @override
  Future<void>? onLoad() async {
    final m = await TiledComponent.load(fileName, Vector2.all(32));
    final regions = m.tileMap.getLayer<ObjectGroup>('regions')!;
    for (var r in regions.objects) {
      if (renderers.containsKey(r.name)) {
        renderers[r.name]!.call(r, m.tileMap, r.name);
      }
    }
  }
}
