import 'package:flutter/material.dart';

import 'card.dart';

class CardDeck extends StatelessWidget {
  const CardDeck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const n = 10;
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      return Stack(
        children: List.generate(n, (index) {
          return Transform.translate(
            offset: Offset(w * 0.01 * index, w * 0.01 * index),
            child: const AppCard(),
          );
        }).reversed.toList(),
      );
    });
  }
}
