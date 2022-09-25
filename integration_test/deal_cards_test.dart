import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/dev/repositories.dart';

import 'test_driver.dart';

void main() {
  testWidgets('Deal cards test', (WidgetTester tester) async {
    final gameRepository = TestGameRepository();
    final testDriver =
        TestDriver(tester: tester, gameRepository: gameRepository);
    await testDriver.onHomeScreen();
    await testDriver.startGame();
    await testDriver.dealCards();
  });
}
