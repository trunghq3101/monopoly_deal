import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/components/card/card_provider.dart';
import 'package:monopoly_deal/game/components/card/card_publisher.dart';
import 'package:monopoly_deal/game/components/card/card_state_machine.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockPublisher extends Component with Publisher<int> {}

void main() {
  group('CardProvider', () {
    late CardProvider cardProvider;

    setUp(() {
      cardProvider = CardProvider();
    });

    test('is a Component', () {
      expect(cardProvider, isA<Component>());
    });

    testWithFlameGame('loaded correctly', (game) async {
      await game.ensureAdd(cardProvider);

      expect(cardProvider.isMounted, true);
    });

    group('get', () {
      testWithFlameGame('exist, return components', (game) async {
        await game.ensureAdd(cardProvider);

        expect(cardProvider.get<CardPublisher>(), isA<CardPublisher>());
        expect(cardProvider.get<CardStateMachine>(), isA<CardStateMachine>());
      });

      testWithFlameGame('not exist, throws exception', (game) async {
        await game.ensureAdd(cardProvider);

        expect(
          () => cardProvider.get<_MockPublisher>(),
          throwsA(isA<PublisherNotFoundException>()),
        );
      });
    });
  });
}
