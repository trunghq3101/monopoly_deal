import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

class _MockGame extends FlameGame with HasTappableComponents {}

void main() {
  group('$HandToggleButton', () {
    late HandToggleButton button;

    setUp(() {
      button = HandToggleButton();
    });

    testWithGame<_MockGame>('loaded correctly', _MockGame.new, (game) async {
      await game.ensureAdd(button);

      expect(button.children.query<ButtonComponent>(), isNotEmpty);
    });
  });
}
