import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';
import 'package:monopoly_deal/widgets/animated_card.dart';
import 'package:monopoly_deal/widgets/card.dart';
import 'package:monopoly_deal/widgets/card_deck.dart';

void main() {
  final dashbook = Dashbook();

  dashbook.storiesOf('$CardDeck').decorator(CenterDecorator()).add(
      'default',
      (ctx) => const FractionallySizedBox(
            widthFactor: 0.2,
            child: CardDeck(),
          ));

  dashbook
      .storiesOf('$AppCard')
      .decorator(CenterDecorator())
      .add(
          'default',
          (ctx) => const FractionallySizedBox(
                widthFactor: 0.2,
                child: AppCard(),
              ))
      .add('animated', (ctx) {
    final controller = AnimatedAppCardController();
    ctx.action('reset', (_) {
      controller.deal(to: Offset(0, 0), angle: 0);
    });
    ctx.action('deal', (_) {
      controller.deal(to: Offset(0, -200));
    });
    return FractionallySizedBox(
      widthFactor: 0.2,
      child: AnimatedAppCard(
        controller: controller,
      ),
    );
  });

  runApp(dashbook);
}
