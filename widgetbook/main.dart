import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';
import 'package:monopoly_deal/widgets/card.dart';
import 'package:monopoly_deal/widgets/card_deck.dart';

void main() {
  final dashbook = Dashbook();

  dashbook
      .storiesOf('$CardDeck')
      .decorator(CenterDecorator())
      .add('default', (ctx) => const CardDeck());

  dashbook.storiesOf('$AppCard').decorator(CenterDecorator()).add(
      'default',
      (ctx) => const FractionallySizedBox(
            widthFactor: 0.8,
            child: AppCard(),
          ));

  runApp(dashbook);
}
