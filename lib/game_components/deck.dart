import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

import 'card.dart';
import 'game_assets.dart';

class BuildDeckTransition extends Transition<DeckState> {
  BuildDeckTransition(super.dest, this.deck);

  final Deck deck;

  @override
  FutureOr<void> onActivate(payload) {
    final cardIds =
        List.generate(Deck.kCardAmount, (index) => index, growable: false)
          ..shuffle();
    var p = 0;
    final cards = cardIds
        .map((id) => Card(
              id: id,
              sprite: deck.cardSprite,
              position: deck.size / 2 +
                  Vector2.all(Card.kCardWidth / 1000) * (Deck.kCardAmount / 2) -
                  Vector2.all(Card.kCardWidth / 1000) * p.toDouble(),
              priority: p++,
            ))
        .toList();
    int currentLoadedCardIndex = 0;
    TimerComponent(
      period: 0.01,
      repeat: true,
      onTick: () async {
        if (currentLoadedCardIndex < Deck.kCardAmount) {
          deck.add(cards[currentLoadedCardIndex++]);
        }
      },
    )
      ..add(RemoveEffect(delay: 1.3))
      ..addToParent(deck);
  }
}

class DealTransition extends Transition {
  DealTransition(super.dest, this.deck);

  final Deck deck;

  @override
  FutureOr<void> onActivate(payload) async {
    final dealTargets = deck.dealTargets;
    // deck.priority = 1;
    // for (var d in dealTargets) {
    //   d.priority = 0;
    // }
    var ti = dealTargets.iterator;
    if (!ti.moveNext()) {
      return;
    }
    var ci = deck.children.query<Card>().reversed.iterator..moveNext();
    final fullDuration = dealTargets.length * 5 * 0.3 + 0.5;
    for (var i = 0; i < dealTargets.length * 5; i++) {
      final d = (i + 1) * 0.3;
      final c = ci.current;
      final t = ti.current;
      c.addAll([
        RotateEffect.by(
          pi * 0.75 + Random(gameAssets.randomSeed()).nextInt(90) * pi / 180,
          EffectController(
              duration: 0.5, curve: Curves.easeOutCubic, startDelay: d),
        ),
        MoveEffect.to(
          t.position + c.size / 2,
          EffectController(
              duration: 0.5, curve: Curves.easeOutCubic, startDelay: d),
        ),
        TimerComponent(
          period: d + 0.2,
          onTick: () {
            c.priority = i;
          },
          removeOnFinish: true,
        ),
        TimerComponent(
          period: fullDuration,
          onTick: () {
            c
              ..changeParent(t)
              ..removed.then((value) => c.position = t.size / 2);
          },
          removeOnFinish: true,
        )
      ]);
      ci.moveNext();
      if (!ti.moveNext()) {
        ti = dealTargets.iterator..moveNext();
      }
    }
  }
}

enum DeckState { initial, built, dealt }

class Deck extends PositionComponent with HasGameRef, HasStateMachine {
  Deck({
    required this.dealTargets,
    required this.cardSprite,
  }) : super(
          position: Vector2(0, 0),
          size: Card.kCardSize,
          anchor: Anchor.center,
        );
  static const kCardAmount = 106;
  static const kBuild = 0;
  static const kDeal = 1;
  final List<PositionComponent> dealTargets;
  final Sprite cardSprite;

  @override
  Future<void>? onLoad() async {
    children.register<Card>();
    newMachine({
      DeckState.initial: {
        Command(kBuild): BuildDeckTransition(DeckState.built, this),
      },
      DeckState.built: {
        Command(kDeal): DealTransition(DeckState.dealt, this),
      },
      DeckState.dealt: {}
    });
  }
}
