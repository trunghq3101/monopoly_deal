// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:monopoly_deal/models/card.dart';
// import 'package:monopoly_deal/models/game_round.dart';
// import 'package:monopoly_deal/models/player.dart';
// import 'package:monopoly_deal/pages/home_page.dart';

// class MockGameRound extends GameRound {
//   var addPlayerCalled = 0;
//   late Player addPlayerArg;

//   @override
//   Future<void> addPlayer(Player player) async {
//     addPlayerCalled++;
//     addPlayerArg = player;
//   }
// }

// void main() {
//   testWidgets('Verify integration GameRound', (tester) async {
//     final game = MockGameRound();
//     final player = Player();
//     await tester.pumpWidget(MaterialApp(
//       home: HomePage(game: game, player: player),
//     ));
//     await tester.tap(find.text('Join'));
//     await tester.pumpAndSettle();
//     expect(game.addPlayerCalled, 1);
//     expect(game.addPlayerArg, player);
//   });
// }
