import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
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

class GameMaster extends Component with HasGameReference<BaseGame> {
  GameMaster({
    required Milestones milestones,
    required CardsGenerator cardsGenerator,
  })  : _milestones = milestones,
        _cardsGenerator = cardsGenerator;

  final Milestones _milestones;
  final CardsGenerator _cardsGenerator;

  void _putTheDeck({
    required Vector2 at,
    required World world,
  }) {
    final cards = _cardsGenerator.generate();
    const spacing = 0.6;
    final diagonalLength = spacing * (_cardsGenerator.deckCapacity - 1);
    final deckBottomRight = Vector2(diagonalLength / 2, 0)..rotate(pi / 4);
    final direction = Vector2(spacing, 0)..rotate(pi + pi / 4);
    const timeStep = 0.006;
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

  void _scheduleResponsesToGameMilestone() {
    TimerComponent(
      period: _milestones.start,
      onTick: () => _putTheDeck(
        at: Vector2.zero(),
        world: game.world,
      ),
      removeOnFinish: true,
    ).addToParent(this);
  }

  @override
  Future<void>? onLoad() async {
    _scheduleResponsesToGameMilestone();
  }
}
