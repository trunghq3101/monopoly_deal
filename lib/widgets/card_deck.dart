import 'package:flutter/material.dart';

import 'card.dart';

class CardDeck extends StatelessWidget {
  const CardDeck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const n = 10;
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: List.generate(n, (index) {
          return Transform.translate(
            offset: Offset(2.0 * index, 2.0 * index),
            child: const AppCard(),
          );
        }).reversed.toList(),
      );
    });
  }
}
