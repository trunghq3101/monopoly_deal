import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';

class CardsGenerator {
  CardsGenerator({required this.randSeed, required this.deckSize});

  final int randSeed;
  final int deckSize;

  List<int> genCardIds() {
    return List.generate(deckSize, (index) => index)..shuffle(Random(randSeed));
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
    required Vector2 size,
    required Anchor anchor,
  }) {
    final ids = _cardsGenerator.genCardIds();
    const spacing = 0.6;
    final diagonalLength = spacing * (_cardsGenerator.deckSize - 1);
    final deckBottomRight = Vector2(diagonalLength / 2, 0)..rotate(pi / 4);
    final direction = Vector2(spacing, 0)..rotate(pi + pi / 4);
    for (var i = 0; i < _cardsGenerator.deckSize; i++) {
      TimerComponent(
        onTick: () {
          CardBack(id: ids[i])
            ..size = size
            ..anchor = anchor
            ..position = deckBottomRight + direction.scaled(spacing * i)
            ..addToParent(world);
        },
        period: 0.006 * i,
        removeOnFinish: true,
      ).addToParent(this);
    }
  }

  void _scheduleResponsesToGameMilestone() {
    add(TimerComponent(
      period: _milestones.start,
      onTick: () => _putTheDeck(
        at: Vector2.zero(),
        world: game.world,
        size: Vector2(300, 440),
        anchor: Anchor.center,
      ),
      removeOnFinish: true,
    ));
  }

  @override
  Future<void>? onLoad() async {
    _scheduleResponsesToGameMilestone();
  }
}
