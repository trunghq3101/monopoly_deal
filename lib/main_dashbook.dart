import 'package:dashbook/dashbook.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:monopoly_deal/dev/game_wrapper.dart';
import 'package:monopoly_deal/game_components/base_game.dart';
import 'package:monopoly_deal/game_components/card_front.dart';
import 'package:monopoly_deal/game_components/hand.dart';
import 'package:monopoly_deal/game_components/main_game_states.dart';
import 'package:monopoly_deal/game_components/playground_map.dart';
import 'package:monopoly_deal/game_components/tappable_overlay.dart';
import 'package:simple_state_machine/simple_state_machine.dart';
import 'package:tiled/tiled.dart';

import 'dev/components.dart';
import 'game_components/card.dart';
import 'game_components/deck.dart';
import 'game_components/game_assets.dart';

void main() {
  final dashbook = Dashbook();

  dashbook
      .storiesOf('2 players game')
      .add('deck', _deck)
      .add('overview', _overview)
      .add('pick up and show hand', _pickUpAndShowHand)
      .add('pick up', _pickUp)
      .add('tap outside', _tapOutside)
      .add('hand', _hand)
      .add('holding cards', _holdingCards)
      .add('5 cards fly to hand', _fiveCardsFlyToHand);

  runApp(dashbook);
}

Widget _deck(ctx) {
  late final Deck deck;
  final game = BaseGame()
    ..onDebug((game) async {
      deck = Deck(dealTargets: [
        PositionComponent(position: Vector2(0, -1000)),
        PositionComponent(position: Vector2(0, 1000)),
      ], cardSprite: gameAssets.sprites['card']!);
      game.viewfinder.visibleGameSize = Vector2.all(1000);
      game.world.add(deck);
      game.newMachine({
        CameraState.initial: {
          Command(Deck.kDeal):
              DealCameraTransition(CameraState.initial, game.cameraComponent),
        }
      });
    });
  ctx.action('build', (_) {
    deck.onCommand(Command(Deck.kBuild));
  });
  ctx.action('deal', (_) {
    deck.onCommand(Command(Deck.kDeal));
    game.onCommand(Command(Deck.kDeal));
  });
  return GameWrapper(game: game);
}

Widget _overview(ctx) {
  final game = BaseGame()
    ..onDebug((game) async {
      game.viewfinder.visibleGameSize = Vector2.all(5000);
      game.world.add(PlaygroundMap(
        'two_players.tmx',
        {
          'deck': (r, _, __) => game.world.add(
                Card(
                    id: 0,
                    position: Vector2(r.x, r.y),
                    sprite: gameAssets.sprites['card']),
              ),
          'deal_region_0': (r, _, __) => game.world.add(
                PositionComponent(
                  position: Vector2(r.x, r.y),
                  size: Vector2(r.width, r.height),
                  anchor: Anchor.center,
                ),
              ),
          'deal_region_1': (r, _, __) => game.world.add(
                PositionComponent(
                  position: Vector2(r.x, r.y),
                  size: Vector2(r.width, r.height),
                  anchor: Anchor.center,
                ),
              ),
          'play_region_0': (r, tiledMap, name) async {
            final slots = tiledMap.getLayer<ObjectGroup>(r.name)!;
            for (var s in slots.objects) {
              game.world.add(PositionComponent(
                position: Vector2(s.x, s.y),
                size: Vector2(
                  (await s.template!)!.object!.width,
                  (await s.template!)!.object!.height,
                ),
                anchor: Anchor.center,
              ));
            }
          },
          'play_region_1': (r, tiledMap, name) async {
            final slots = tiledMap.getLayer<ObjectGroup>(r.name)!;
            for (var s in slots.objects) {
              game.world.add(PositionComponent(
                position: Vector2(s.x, s.y),
                size: Vector2(
                  (await s.template!)!.object!.width,
                  (await s.template!)!.object!.height,
                ),
                anchor: Anchor.center,
              ));
            }
          }
        },
      ));
      game.viewfinder.position = Vector2.zero();
    });
  ctx.action('pick', (_) {});
  return GameWrapper(game: game);
}

Widget _pickUpAndShowHand(ctx) {
  final hand = Hand();
  final game = BaseGame()
    ..onDebug((game) async {
      game.add(hand);
      game.viewfinder.visibleGameSize = Vector2.all(2000);
      game.world.children.register<Card>();
      final s = await Sprite.load('card.png');
      game.world.addAll(List.generate(
        5,
        (index) => Card(
          id: index,
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
    hand.onCommand(Command(
        Hand.kPickUp,
        game.world.children
            .query<Card>()
            .reversed
            .map(
              (e) => CardFront(
                id: e.id,
                sprite: gameAssets.cardSprites[e.id],
                size: Card.kCardSize,
                anchor: Anchor.topCenter,
              ),
            )
            .toList()));
  });
  return GameWrapper(game: game);
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
      Hand.kPickUp,
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
      Hand.kPickUp,
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
      hand.onCommand(Command(Hand.kTapOutsideHand));
    })
    ..action('expand', (_) {
      hand.onCommand(Command(Hand.kTapInsideHand));
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
