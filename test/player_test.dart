import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/game_round.dart';

import 'utils.dart';

void main() {
  group('Player test', () {
    test('Can only draw when it is her turn', () {
      final game = TestUtils.getGame();
      final player = game.players[0];
      expect(() => player.draw(), throwsException);
      game.turnTo(player: player);
      player.draw();
    });

    test('Know what the next step is in her turn', () {
      final game = TestUtils.getGame();
      final player = game.players[0];
      game.turnOwner = player;
      expect(player.nextStep(), Steps.draw);
      expect(player.nextStep(), Steps.play);
      expect(player.nextStep(), Steps.drop);
      expect(player.nextStep(), Steps.end);
    });
  });
}
