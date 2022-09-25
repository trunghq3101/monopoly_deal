import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';
import 'package:monopoly_deal/widgets/card_deck.dart';

void main() {
  final dashbook = Dashbook();

  dashbook
      .storiesOf('$CardDeck')
      .decorator(CenterDecorator())
      .add('default', (ctx) => const CardDeck());

  runApp(dashbook);
}
