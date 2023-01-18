import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';

class CardTracker extends Component
    with HasGameReference<FlameGame>, HasWorldRef {
  CardTracker() {
    _setupHandCurve();
  }

  late final double handCurveWidth;
  late final PathMetric pathMetrics;

  List<Card> get allCards => world.children.query<Card>();

  List<HasCardIndex> cardsInDeckFromTop() {
    final cards = allCards.where((c) => c.state == CardState.inDeck).toList();
    cards.sort((a, b) => b.priority.compareTo(a.priority));
    return cards;
  }

  List<HasCardIndex> cardsInMyDealRegionFromTop() {
    final cards =
        allCards.where((c) => c.state == CardState.inMyDealRegion).toList();
    cards.sort((a, b) => b.priority.compareTo(a.priority));
    return cards;
  }

  List<HasCardIndex> cardsNotInMyDealRegion() {
    final cards =
        allCards.where((c) => c.state != CardState.inMyDealRegion).toList();
    return cards;
  }

  List<HasCardIndex> cardsByIndexFromTop(List<int> indexes) {
    final cards = allCards.where((c) => indexes.contains(c.cardIndex)).toList();
    cards.sort((a, b) => b.priority.compareTo(a.priority));
    return cards;
  }

  List<HasCardIndex> cardsInHandCollapsedFromTop() {
    final cards =
        allCards.where((c) => c.state == CardState.inHandCollapsed).toList();
    cards.sort((a, b) => b.priority.compareTo(a.priority));
    return cards;
  }

  Card? cardInPreviewingState() {
    return allCards.where((c) => c.state == CardState.inPreviewing).firstOrNull;
  }

  InHandPosition getInHandPosition({required int index, required int amount}) {
    final spacing = handCurveWidth / (amount - 1);
    final tangent = pathMetrics.getTangentForOffset(index * spacing)!;
    final position = Vector2(tangent.position.dx, tangent.position.dy);
    return InHandPosition(position, tangent.vector.direction);
  }

  InHandPosition getInHandPositionForOpponent(
      {required int relativePlayerIndex,
      required int playerAmount,
      required int index,
      required int amount}) {
    final spacing = handCurveWidth / (amount - 1);
    final tangent = pathMetrics.getTangentForOffset(index * spacing)!;
    final position = Vector2(tangent.position.dx, tangent.position.dy)
        .scaled(0.2)
      ..add(MainGame.gameMap.handPositionForOpponent(relativePlayerIndex));
    return InHandPosition(position, tangent.vector.direction);
  }

  InHandPosition getInHandCollapsedPosition(
      {required int index, required int amount}) {
    double offset;
    if (amount == 1) {
      offset = handCurveWidth / 2;
    } else if (amount == 2) {
      offset = handCurveWidth / 4 + index * handCurveWidth / 2;
    } else {
      offset = index * handCurveWidth / (amount - 1);
    }
    final tangent = pathMetrics.getTangentForOffset(offset)!;
    final position = Vector2(tangent.position.dx,
        tangent.position.dy + MainGame.gameMap.cardSizeInHand.y * 0.8);
    return InHandPosition(position, tangent.vector.direction);
  }

  bool hasCardInAnimationState() {
    return allCards.any((c) => c.state == CardState.inAnimation);
  }

  void _setupHandCurve() {
    handCurveWidth = MainGame.gameMap.overviewGameVisibleSize.x * 0.4;
    final handCurveStart = Vector2(
        -handCurveWidth / 2, MainGame.gameMap.overviewGameVisibleSize.y * 0.4);
    final handCurveEnd = handCurveStart + Vector2(handCurveWidth, 0);
    final handCurveRadius =
        Radius.elliptical(handCurveWidth, handCurveWidth / 2);
    final handCurve = Path()
      ..moveTo(handCurveStart.x, handCurveStart.y)
      ..arcToPoint(
        Offset(handCurveEnd.x, handCurveEnd.y),
        radius: handCurveRadius,
      );
    pathMetrics = handCurve.computeMetrics().first;
  }
}
