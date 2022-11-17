import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/foundation.dart';
import 'package:monopoly_deal/game/game.dart';

class CardsGenerator {
  CardsGenerator({
    required this.randSeed,
    required this.deckCapacity,
    required this.cardSize,
    required this.cardAnchor,
  });

  final int randSeed;
  final int deckCapacity;
  final Vector2 cardSize;
  final Anchor cardAnchor;

  List<CardBack> generate() {
    final ids = List.generate(deckCapacity, (index) => index)
      ..shuffle(Random(randSeed));
    return ids
        .map((id) => CardBack(id: id)
          ..size = cardSize
          ..anchor = cardAnchor)
        .toList();
  }
}

enum GameMasterEvent {
  startDealing,
}

class GameMasterBroadcaster extends ValueNotifier<GameMasterEvent?> {
  GameMasterBroadcaster(super.value);
}

class GameMaster extends Component with HasGameReference<BaseGame> {
  GameMaster({
    required Milestones milestones,
    required CardsGenerator cardsGenerator,
    required GameMasterBroadcaster broadcaster,
  })  : _milestones = milestones,
        _cardsGenerator = cardsGenerator,
        _broadcaster = broadcaster;

  final Milestones _milestones;
  final CardsGenerator _cardsGenerator;
  final GameMasterBroadcaster _broadcaster;

  void _putTheDeck({
    required Vector2 at,
    required World world,
    required double timeStep,
  }) {
    final cards = _cardsGenerator.generate();
    const spacing = 0.6;
    final diagonalLength = spacing * (_cardsGenerator.deckCapacity - 1);
    final deckBottomRight = Vector2(diagonalLength / 2, 0)..rotate(pi / 4);
    final direction = Vector2(spacing, 0)..rotate(pi + pi / 4);
    for (var i = 0; i < _cardsGenerator.deckCapacity; i++) {
      TimerComponent(
        onTick: () {
          cards[i]
            ..position = deckBottomRight + direction.scaled(spacing * i)
            ..addToParent(world);
        },
        period: timeStep * i,
        removeOnFinish: true,
      ).addToParent(this);
    }
  }

  void _dealCards() {
    _broadcaster.value = GameMasterEvent.startDealing;
  }

  void _scheduleMoves() {
    const timeStep = 0.006;
    final dealCards =
        _milestones.start + timeStep * _cardsGenerator.deckCapacity - 1 + 1.3;
    final moves = {
      _milestones.start: () => _putTheDeck(
            at: Vector2.zero(),
            world: game.world,
            timeStep: timeStep,
          ),
      dealCards: _dealCards,
    };
    for (var move in moves.entries) {
      TimerComponent(period: move.key, onTick: move.value, removeOnFinish: true)
          .addToParent(this);
    }
  }

  @override
  Future<void>? onLoad() async {
    _scheduleMoves();
  }
}
