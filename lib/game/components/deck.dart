import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class DeckConfig {
  final Vector2 step;
  final int total;
  final Vector2 bottomRight;

  DeckConfig({
    required this.step,
    required this.total,
    required this.bottomRight,
  });

  factory DeckConfig.game() => DeckConfig(
        bottomRight: Vector2(0.4 * 109 / 2, 0)..rotate(pi / 4),
        step: Vector2.all(-0.4),
        total: 110,
      );
}

class Deck extends Component {
  Deck({required this.config});

  final DeckConfig config;
  final ValueNotifier amountNotifier = ValueNotifier(0);
  int get amount => amountNotifier.value;
  List<Vector2> newCards = [];

  double _elapsed = 0.0;

  @override
  void update(double dt) {
    final oldAmount = amount;
    amountNotifier.value = min(((_elapsed += dt) / 0.01).floor(), config.total);
    final numToAdd = amount - oldAmount;
    var lastBottomRight =
        newCards.isEmpty ? config.bottomRight - config.step : newCards.last;
    newCards = List.generate(numToAdd, (_) {
      final newPosition = lastBottomRight + config.step;
      lastBottomRight = newPosition;
      return newPosition;
    });
    if (amount == config.total) {
      amountNotifier.dispose();
      removeFromParent();
    }
  }
}
