import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:monopoly_deal/widgets/animated_card.dart';

class CardDeckController extends ChangeNotifier {
  List<AnimatedAppCardController> controllers =
      List.generate(10, (index) => AnimatedAppCardController());
  List<GlobalKey> cardKeys = List.generate(10, (index) => GlobalKey());
  int nextIndex = 0;

  void deal({required List<Offset> targets}) {
    var c = 0;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (c == targets.length) {
        timer.cancel();
        return;
      }
      final nextController = controllers.removeAt(nextIndex);
      final nextKey = cardKeys.removeAt(nextIndex);
      controllers.insert(0, nextController);
      cardKeys.insert(0, nextKey);
      nextController.deal(to: targets[c]);
      nextIndex++;
      c++;
      controllers.add(AnimatedAppCardController());
      cardKeys.add(GlobalKey());
      notifyListeners();
    });
  }
}

class CardDeck extends StatelessWidget {
  const CardDeck({
    Key? key,
    required this.cardDeckController,
  }) : super(key: key);

  final CardDeckController cardDeckController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final spacing = min(constraints.maxWidth, constraints.maxHeight) * 0.01;
      return RepaintBoundary(
        child: AnimatedBuilder(
          animation: cardDeckController,
          builder: (_, child) {
            return Stack(
              children: [
                ...List.generate(cardDeckController.controllers.length,
                    (index) {
                  var offset = spacing * (index - cardDeckController.nextIndex);
                  if (offset < 0) offset = 0;
                  return Transform.translate(
                    offset: Offset(offset, offset),
                    child: AnimatedAppCard(
                      key: cardDeckController.cardKeys[index],
                      controller: cardDeckController.controllers[index],
                    ),
                  );
                }).reversed.toList(),
              ],
            );
          },
        ),
      );
    });
  }
}
