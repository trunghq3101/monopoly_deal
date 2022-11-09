import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/game_components/card_front.dart';
import 'package:monopoly_deal/game_components/extensions.dart';
import 'package:monopoly_deal/game_components/mixins.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

class ExpandTransition extends Transition {
  final Hand hand;

  ExpandTransition(super.stateMachine, this.hand);

  @override
  State? onActivate(Command command) {
    hand.add(MoveEffect.by(
      Vector2(0, -(hand.size.y - 100)),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
    return stateMachine.state(HandState.expanded);
  }
}

class CollapseTransition extends Transition {
  final Hand hand;

  CollapseTransition(super.stateMachine, this.hand);

  @override
  State? onActivate(Command command) {
    hand.add(MoveEffect.by(
      Vector2(0, hand.size.y - 100),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
    return stateMachine.state(HandState.collapsed);
  }
}

class AddCardsTransition extends Transition {
  final Hand hand;

  AddCardsTransition(super.stateMachine, this.hand);

  @override
  State? onActivate(Command command) {
    final c = command as PickUpCommand;
    hand.preparePositionsForMore(c.cards.length);
    hand.shiftCards();
    hand.addCards(command.cards);
    hand.updatePositions();
    return stateMachine.state(HandState.notEmpty);
  }
}

class PickUpCommand extends Command {
  PickUpCommand(super.id, this.cards);

  final List<CardFront> cards;
}

const kTapOutsideHand = 0;
const kTapInsideHand = 1;
const kPickUp = 2;

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

class Hand extends HudMarginComponent with TapCallbacks, TapOutsideCallback {
  Hand({super.children})
      : super(
          anchor: Anchor.bottomCenter,
          position: Vector2.zero(),
        );

  final _stateMachines = [
    StateMachine()..start(HandState.expanded),
    StateMachine()..start(HandState.empty),
  ];
  final _oldCardPositions = <CardPosition>[];
  final List<CardPosition> _newCardPositions = [];
  late CircleComponent _circle;
  late double _startingAngle;
  late double _angleDiff;

  @override
  Future<void> onLoad() async {
    position = Vector2(gameRef.size.x / 2, gameRef.size.y);
    size = _calcSize(gameRef.size);
    super.onLoad();
    children.register<CardFront>();
    _stateMachines[0]
      ..addTransition(
        HandState.collapsed,
        MapEntry(
            Command(kTapInsideHand), ExpandTransition(_stateMachines[0], this)),
      )
      ..addTransition(
        HandState.expanded,
        MapEntry(Command(kTapOutsideHand),
            CollapseTransition(_stateMachines[0], this)),
      );
    _stateMachines[1]
      ..addTransition(
          HandState.empty,
          MapEntry(
              Command(kPickUp), AddCardsTransition(_stateMachines[1], this)))
      ..addTransition(
          HandState.notEmpty,
          MapEntry(
              Command(kPickUp), AddCardsTransition(_stateMachines[1], this)));
    final r = width * 1.25;
    final circleCenterX = width / 2 + width / 16;
    final paddingH = width / 5;
    final paddingT = width / 16;
    _circle = CircleComponent(
      radius: r,
      position: Vector2(circleCenterX, paddingT),
      anchor: Anchor.topCenter,
      paint: BasicPalette.transparent.paint(),
    );
    add(_circle);
    final rAngle = pi / 2 - acos((width - circleCenterX - paddingH) / r);
    final lAngle = -(pi / 2 - acos((circleCenterX - paddingH) / r));
    _angleDiff = rAngle - lAngle;
    _startingAngle = rAngle;
  }

  @override
  void onTapDown(TapDownEvent event) {
    tapOutsideSubscribed = true;
    onCommand(Command(kTapInsideHand));
  }

  @override
  void onTapOutside() {
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

  void onCommand(Command command) {
    for (var m in _stateMachines) {
      m.onCommand(command);
    }
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
    return vector.reflected(Vector2(0, 1)) + _circle.size / 2;
  }

  Vector2 _calcSize(Vector2 size) => size.x * 3 / 4 < size.y - 20
      ? Vector2(size.x, size.x * 3 / 4)
      : Vector2((size.y - 20) * 4 / 3, size.y - 20)
    ..clamp(Vector2.zero(), Vector2(800, 600));
}
