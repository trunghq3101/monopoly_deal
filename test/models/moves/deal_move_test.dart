import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/card.dart';
import 'package:monopoly_deal/models/moves/deal_move.dart';
import 'package:monopoly_deal/models/player.dart';

void main() {
  group('DealMove test', () {
    test('deal', () {
      final dealer = Player();
      final deck = CardDeck();
      final players = [
        Player(),
        Player(),
      ];
      final move = DealMove(
        player: dealer,
        deck: deck,
        players: players,
      );
      move.move();
      expect(players[0].hand.length, 5);
      expect(players[1].hand.length, 5);
      expect(deck.currentLength, 100);
    });
  });
}
