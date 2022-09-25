import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/card.dart';
import 'package:monopoly_deal/models/moves/move_model.dart';
import 'package:monopoly_deal/models/player.dart';

void main() {
  group('DealMove test', () {
    test('deal', () {
      final dealer = Player();
      final cards = List.generate(10, (index) => Card('$index'));
      final players = [
        Player(),
        Player(),
      ];
      final cards0 = [cards[9], cards[7], cards[5], cards[3], cards[1]];
      // final move = DealMove(player: dealer, cards: cards0);
      // move.move();
      // expect(
      //   players[0].hand,
      //   cards0,
      // );
    });

    // test('error if not enough cards', () {
    //   final dealer = Player();
    //   final cards = List.generate(10, (index) => Card('$index'));
    //   final deck = CardDeck(initial: cards);
    //   final players = [
    //     Player(),
    //     Player(),
    //     Player(),
    //   ];
    //   final move = DealMove(
    //     player: dealer,
    //     deck: deck,
    //     players: players,
    //   );
    //   expect(() => move.move(), throwsAssertionError);
    // });
  });
}
