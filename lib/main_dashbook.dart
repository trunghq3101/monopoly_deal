import 'package:dashbook/dashbook.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:monopoly_deal/dev/game_wrapper.dart';
import 'package:monopoly_deal/dev/table_layout_game.dart';
import 'package:monopoly_deal/game_components/base_game.dart';
import 'package:monopoly_deal/game_components/card_front.dart';
import 'package:monopoly_deal/game_components/hand.dart';
import 'package:monopoly_deal/game_components/tappable_overlay.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

import 'dev/components.dart';
import 'game_components/card.dart';
import 'game_components/game_assets.dart';

void main() {
  final dashbook = Dashbook();

  dashbook
      .storiesOf('2 players game')
      .add('pick up', _pickUp)
      .add('overview', _overview)
      .add('tap outside', _tapOutside)
      .add('hand', _hand)
      .add('holding cards', _holdingCards)
      .add('5 cards fly to hand', _fiveCardsFlyToHand);

  runApp(dashbook);
}

Widget _pickUp(ctx) {
  final game = BaseGame()
    ..onDebug((game) async {
      game.viewfinder.visibleGameSize = Vector2.all(2000);
      game.world.children.register<Card>();
      final s = await Sprite.load('card.png');
      game.world.addAll(List.generate(
        5,
        (index) => Card(
          id: 0,
          position: Vector2.zero(),
          sprite: s,
        )..angle = 0.2 * index,
      ));
    });
  var delay = 0.0;
  ctx.action('pick', (_) {
    for (var c in game.world.children.query<Card>().reversed) {
      c.onCommand(Command(Card.kPickUp, delay += 0.1));
    }
  });
  return GameWrapper(game: game);
}

Widget _fiveCardsFlyToHand(ctx) {
  final hand = Hand();
  final game = BaseGame()
    ..onDebug((game) {
      game.add(TappableOverlay());
      game.add(hand);
    });
  var i = 0;
  ctx.action('add 5', (_) {
    hand.onCommand(Command(
      kPickUp,
      List.generate(
        5,
        (index) => CardFront(
          id: ++i,
          sprite: gameAssets.cardSprites[i],
          size: Card.kCardSize,
          anchor: Anchor.topCenter,
        ),
      ),
    ));
  });
  ctx.action('add 2', (_) {
    hand.onCommand(Command(
      kPickUp,
      List.generate(
        2,
        (index) => CardFront(
          id: ++i,
          sprite: gameAssets.cardSprites[i],
          size: Card.kCardSize,
          anchor: Anchor.topCenter,
        ),
      ),
    ));
  });
  return GameWrapper(game: game);
}

Widget _holdingCards(ctx) {
  final hand = Hand();
  final game = BaseGame()
    ..onDebug((game) {
      game.add(hand);
    });
  return GameWrapper(game: game);
}

Widget _hand(ctx) {
  final hand = Hand();
  final game = BaseGame()
    ..onDebug((game) {
      game.add(TappableOverlay());
      game.add(hand);
    });
  ctx
    ..action('collapse', (_) {
      hand.onCommand(Command(kTapOutsideHand));
    })
    ..action('expand', (_) {
      hand.onCommand(Command(kTapInsideHand));
    });
  return GameWrapper(game: game);
}

Widget _tapOutside(ctx) {
  final game = BaseGame()
    ..onDebug((game) {
      game.add(TappableOverlay());
      game.add(TestComponent1()..size = Vector2.all(400));
      game.add(TestComponent2()
        ..size = Vector2.all(400)
        ..position = Vector2.all(500));
    });
  return GameWrapper(game: game);
}

Widget _overview(ctx) {
  final game = TableLayoutGame();
  return GameWrapper(game: game);
}
