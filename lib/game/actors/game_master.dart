import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/game/game.dart';

class Deck {
  Deck({
    required this.randSeed,
    required this.deckCapacity,
    required this.cardSize,
    required this.cardAnchor,
  });

  final int randSeed;
  final int deckCapacity;
  final Vector2 cardSize;
  final Anchor cardAnchor;
  final List<CardBack> cards = [];

  void initialize() {
    final ids = List.generate(deckCapacity, (index) => index)
      ..shuffle(Random(randSeed));
    cards.addAll(ids.map((id) => CardBack(id: id)
      ..size = cardSize
      ..anchor = cardAnchor));
  }
}

class GameMaster extends Component with HasGameRef<BaseGame> {
  GameMaster({
    required Milestones milestones,
    required Deck deck,
  })  : _milestones = milestones,
        _deck = deck;

  final Milestones _milestones;
  final Deck _deck;

  void _putTheDeck({
    required Vector2 at,
    required World world,
    required double timeStep,
  }) {
    _deck.initialize();
    const spacing = 0.6;
    final diagonalLength = spacing * (_deck.deckCapacity - 1);
    final deckBottomRight = Vector2(diagonalLength / 2, 0)..rotate(pi / 4);
    final direction = Vector2(spacing, 0)..rotate(pi + pi / 4);
    for (var i = 0; i < _deck.deckCapacity; i++) {
      TimerComponent(
        onTick: () {
          _deck.cards[i]
            ..position = deckBottomRight + direction.scaled(spacing * i)
            ..addToParent(world);
        },
        period: timeStep * i,
        removeOnFinish: true,
      ).addToParent(this);
    }
  }

  void _dealCards({
    required List<Vector2> toTargets,
    required List<CardBack> cardsInTopToBottomOrder,
    required int amountPerEach,
    required double timeStep,
  }) {
    gameRef.children
        .query<CameraMan>()
        .firstOrNull
        ?.zoomOutToSize(GameSize.visibleAfterDealing.size);

    var remaining = amountPerEach * toTargets.length;
    assert(remaining <= cardsInTopToBottomOrder.length,
        "Not enough cards to deal");

    const durationPerEach = 0.2;
    const randSeed = 1;
    final noise = SimplexNoise(Random(randSeed));

    var nextCardIndex = 0;
    var nextTargetIndex = 0;
    var nextPriority = 0;
    while (remaining > 0) {
      final delay = timeStep * nextCardIndex;
      final randomValue =
          noise.noise2D(10 + nextCardIndex * 30, 10 + nextCardIndex * 10) * 100;
      final randomOffset = Vector2.all(randomValue);
      final c = cardsInTopToBottomOrder[nextCardIndex];
      c.addAll([
        MoveEffect.to(
          toTargets[nextTargetIndex] + randomOffset,
          DelayedEffectController(
              CurvedEffectController(durationPerEach, Curves.fastOutSlowIn),
              delay: delay),
        ),
        RotateEffect.by(
          randomValue % (pi * 2),
          DelayedEffectController(
              CurvedEffectController(durationPerEach, Curves.fastOutSlowIn),
              delay: delay),
        ),
        TimerComponent(
          onTick: () {
            c.priority = nextPriority;
            nextPriority++;
          },
          period: delay,
          removeOnFinish: true,
        )
      ]);
      nextCardIndex++;
      nextTargetIndex = (nextTargetIndex + 1) % toTargets.length;
      remaining--;
    }
  }

  void _allowPickUp({required Vector2 playerPickUpPosition}) {
    PickUpRegion()
      ..position = playerPickUpPosition
      ..size = Vector2.all(GameSize.cardOnTable.y * 1.4)
      ..anchor = Anchor.center
      ..addToParent(gameRef.world);
  }

  void _scheduleMoves() {
    const putTheDeckTimeStep = 0.006;
    final putTheDeckDuration = putTheDeckTimeStep * (_deck.deckCapacity - 1);
    const dealCardsTimeStep = 0.2;
    final dealCardsTarget = [
      GamePosition.dealTargetMe.position,
      GamePosition.dealTarget1.position,
    ];
    const dealCardsAmountPerEach = 5;

    final startDealing = _milestones.start + putTheDeckDuration + 0.3;
    final finishDealing = startDealing +
        dealCardsTimeStep * dealCardsAmountPerEach * dealCardsTarget.length;

    final moves = {
      _milestones.start: () => _putTheDeck(
            at: GamePosition.deck.position,
            world: gameRef.world,
            timeStep: putTheDeckTimeStep,
          ),
      startDealing: () => _dealCards(
            toTargets: dealCardsTarget,
            cardsInTopToBottomOrder: _deck.cards.reversed.toList(),
            amountPerEach: dealCardsAmountPerEach,
            timeStep: dealCardsTimeStep,
          ),
      finishDealing: () {
        _allowPickUp(
          playerPickUpPosition: GamePosition.dealTargetMe.position,
        );
        final opponentFacingDownCards = gameRef.world
            .componentsAtPoint(GamePosition.dealTarget1.position)
            .whereType<CardBack>()
            .toList();
        gameRef.children
            .query<Opponent>()
            .firstOrNull
            ?.pickUpCards(facingDownCardsByTopMost: opponentFacingDownCards);
      },
    };

    for (var move in moves.entries) {
      TimerComponent(
        period: move.key,
        onTick: move.value.call,
        removeOnFinish: true,
      ).addToParent(this);
    }
  }

  @override
  Future<void>? onLoad() async {
    _scheduleMoves();
  }
}
