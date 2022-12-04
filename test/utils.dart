import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

final defaultSize = Vector2(800, 600);

Future<Image> loadTestImage(String fileName) async {
  final f = File.fromUri(Uri.file("test/assets/$fileName"));
  final b = f.readAsBytesSync();
  final completer = Completer<Image>();
  decodeImageFromList(b, completer.complete);
  return await completer.future;
}

class TestEntity extends Entity {}
