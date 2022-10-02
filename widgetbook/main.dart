import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/widgets/animated_card.dart';
import 'package:monopoly_deal/widgets/card.dart';
import 'package:monopoly_deal/widgets/card_deck.dart';

void main() {
  final dashbook = Dashbook(
    theme: ThemeData.dark(),
  );

  dashbook.storiesOf('$CardDeck').decorator(CenterDecorator()).add(
    'default',
    (ctx) {
      final cardDeckController = CardDeckController();
      ctx.action('deal', (_) {
        cardDeckController.deal(targets: const [
          Offset(0, -300),
          Offset(0, 310),
          Offset(0, -320),
          Offset(0, 330),
          Offset(0, -310),
          Offset(0, 320),
          Offset(0, -330),
          Offset(0, 300),
          Offset(0, -320),
          Offset(0, 310),
        ]);
      });
      return FractionallySizedBox(
        heightFactor: 0.18,
        child: CardDeck(cardDeckController: cardDeckController),
      );
    },
  );

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
      controller.deal(to: const Offset(0, 0), angle: 0);
    });
    ctx.action('deal', (_) {
      controller.deal(to: const Offset(0, -200));
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
