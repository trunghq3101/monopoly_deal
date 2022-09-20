import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('Player test', () {
    test('Can only draw when it is her turn', () {
      final game = TestUtils.getGame(started: true);
      final player = game.players[0];
      expect(() => player.draw(), throwsException);
      game.turnTo(player: player);
      player.draw();
    });
  });
}
