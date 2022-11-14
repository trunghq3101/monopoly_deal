import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/features/cards/card_front.dart';
import 'package:monopoly_deal/game_components/extensions.dart';
import 'package:monopoly_deal/game_components/mixins.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

class ExpandTransition extends Transition<HandState> {
  final Hand hand;

  ExpandTransition(super.dest, this.hand);

  @override
  void onActivate(dynamic payload) {
    hand.add(MoveEffect.to(
      Vector2(hand.game.size.x / 2, hand.game.size.y),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
  }
}

class CollapseTransition extends Transition<HandState> {
  final Hand hand;

  CollapseTransition(super.dest, this.hand);

  @override
  void onActivate(dynamic payload) {
    hand.add(MoveEffect.to(
      Vector2(hand.game.size.x / 2, hand.game.size.y * 1.1),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
  }
}

class AddCardsTransition extends Transition<HandState> {
  final Hand hand;

  AddCardsTransition(super.dest, this.hand);

  @override
  void onActivate(dynamic payload) {
    final List<CardFront> cards = payload;
    hand.preparePositionsForMore(cards.length);
    hand.shiftCards();
    hand.addCards(cards);
    hand.updatePositions();
  }
}

class CardPosition {
  int? cardId;
  final Vector2 position;
  final double angle;

  CardPosition(this.position, this.angle);
}

enum HandState {
  collapsed,
  expanded,
  empty,
  notEmpty,
}

class Hand extends PositionComponent
    with TapCallbacks, TapOutsideCallback, HasStateMachine, HasGameReference {
  Hand({super.children});
  static const kTapOutsideHand = 0;
  static const kTapInsideHand = 1;
  static const kPickUp = 2;
  final _oldCardPositions = <CardPosition>[];
  final List<CardPosition> _newCardPositions = [];
  final CircleComponent _circle = CircleComponent(
    anchor: Anchor.topCenter,
    paint: BasicPalette.transparent.paint(),
  );
  late double _startingAngle;
  late double _angleDiff;
  late StateMachine _fillUpMachine;
  late StateMachine positionMachine;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    children.register<CardFront>();
    positionMachine = newMachine<HandState>({
      HandState.expanded: {
        Command(kTapOutsideHand): CollapseTransition(HandState.collapsed, this),
      },
      HandState.collapsed: {
        Command(kTapInsideHand): ExpandTransition(HandState.expanded, this),
      }
    });
    _fillUpMachine = newMachine<HandState>({
      HandState.empty: {
        Command(kPickUp): AddCardsTransition(HandState.notEmpty, this),
      },
      HandState.notEmpty: {
        Command(kPickUp): AddCardsTransition(HandState.notEmpty, this),
      }
    });

    final r = width * 4;
    final circleCenterX = width / 2 + width / 16;
    final paddingH = width / 4;
    _circle
      ..radius = r
      ..position = Vector2(circleCenterX, 0);
    add(_circle);

    final rAngle = pi / 2 - acos((width - circleCenterX - paddingH) / r);
    final lAngle = -(pi / 2 - acos((circleCenterX - paddingH) / r));
    _angleDiff = rAngle - lAngle;
    _startingAngle = rAngle;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_fillUpMachine.current.identifier == HandState.empty) {
      event.continuePropagation = true;
      return;
    }
    tapOutsideSubscribed = true;
    onCommand(Command(kTapInsideHand));
  }

  @override
  void onTapOutside() {
    if (_fillUpMachine.current.identifier == HandState.empty) {
      return;
    }
    tapOutsideSubscribed = false;
    onCommand(Command(kTapOutsideHand));
  }

  void preparePositionsForMore(int n) {
    _preparePositions(n + _circle.children.query<CardFront>().length);
  }

  void shiftCards() {
    var i = _newCardPositions.length - 1;
    var o = _oldCardPositions.length - 1;
    while (o >= 0) {
      final c = _circle.children
          .query<CardFront>()
          .firstWhere((e) => e.id == _oldCardPositions[o].cardId);
      c.addAll([
        MoveEffect.to(
          _newCardPositions[i].position,
          CurvedEffectController(0.2, Curves.easeOutCubic),
        ),
        RotateEffect.to(
          _newCardPositions[i].angle,
          CurvedEffectController(0.2, Curves.easeOutCubic),
        ),
      ]);
      _newCardPositions[i].cardId = _oldCardPositions[o].cardId;
      i--;
      o--;
    }
  }

  void addCards(List<CardFront> cards) {
    final unplacedPositions =
        _newCardPositions.where((p) => p.cardId == null).toList();
    for (var i = unplacedPositions.length - 1; i >= 0; i--) {
      _circle.add(cards[i]);
    }
    for (var i = 0; i < unplacedPositions.length; i++) {
      final c = cards[i];
      c.position = Vector2(0, _circle.height * 1.2);
      unplacedPositions[i].cardId = c.id;
      c.addAll([
        MoveEffect.to(
          unplacedPositions[i].position,
          DelayedEffectController(
            delay: i * 0.1,
            CurvedEffectController(0.5, Curves.easeOutCubic),
          ),
        ),
        RotateEffect.to(
          unplacedPositions[i].angle,
          DelayedEffectController(
            delay: i * 0.1,
            CurvedEffectController(0.5, Curves.easeOutCubic),
          ),
        ),
      ]);
    }
  }

  void updatePositions() {
    _oldCardPositions.clear();
    _oldCardPositions.addAll(_newCardPositions);
    _newCardPositions.clear();
  }

  void _preparePositions(int n) {
    final angleSpacing = _angleDiff / (n - 1);
    for (var i = 0; i < n; i++) {
      final angle = _startingAngle - angleSpacing * i;
      _newCardPositions.add(CardPosition(
        _transitionFromTopLeftToBottomCenter(
          angle.angleToVector2(_circle.radius),
        ),
        angle,
      ));
    }
  }

  Vector2 _transitionFromTopLeftToBottomCenter(Vector2 vector) {
    return vector.reflected(Vector2(0, 1)) + _circle.scaledSize / 2;
  }
}
