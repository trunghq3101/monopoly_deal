import 'package:flutter/material.dart';

import 'card.dart';

class CardDeck extends StatelessWidget {
  const CardDeck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final n = 3;
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: List.generate(n, (index) {
          return Container();
        }),
      );
    });
  }
}
