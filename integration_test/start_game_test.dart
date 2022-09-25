import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/dev/repositories.dart';
import 'package:monopoly_deal/pages/home_page.dart';

import 'steps.dart';

void main() {
  testWidgets('Start game', (tester) async {
    final gameRepository = TestGameRepository();
    await tester.pumpWidget(MaterialApp(
      home: HomePage(gameRepository: gameRepository),
    ));
    await TestDriver(tester: tester, gameRepository: gameRepository)
        .startGame();
  });
}
