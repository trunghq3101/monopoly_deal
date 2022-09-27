import 'package:flutter/material.dart';
import 'package:monopoly_deal/widgets/card_deck.dart';

import '../repositories/game_repository.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    Key? key,
    required this.gameRepository,
  }) : super(key: key);

  final GameRepository gameRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.2,
          child: CardDeck(
            cardDeckController: CardDeckController(),
          ),
        ),
      ),
    );
  }
}
