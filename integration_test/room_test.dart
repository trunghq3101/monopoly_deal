import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/main_app.dart';

void main() {
  group('Room', () {
    testWidgets('User 1 can create a room', (tester) async {
      final roomGateway = RoomGateway();
      await tester.pumpFrames(
          MainApp(roomGateway: roomGateway), const Duration(seconds: 3));
      final button = find.text('Create room');
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text(roomGateway.roomId!), findsOneWidget);
      expect(
        find.byWidgetPredicate(
            (widget) => widget is Member && widget.id != null),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((widget) =>
            widget is Member && widget.id == roomGateway.members![0]),
        findsOneWidget,
      );
    }, timeout: Timeout.parse('10s'));

    testWidgets('User 2 can join the room using the correct room code',
        (tester) async {
      final user1RoomGateway = RoomGateway();
      await user1RoomGateway.createRoom();
      final roomGateway = RoomGateway();
      await tester.pumpFrames(
          MainApp(roomGateway: roomGateway), const Duration(seconds: 3));
      final button = find.text('Join room');
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('enterCode')), user1RoomGateway.roomId!);
      await tester.pump();
      await tester.tap(find.text('Join'));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text(user1RoomGateway.roomId!), findsOneWidget);
      expect(
        find.byWidgetPredicate((widget) =>
            widget is Member && widget.id == roomGateway.members![0]),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((widget) =>
            widget is Member && widget.id == roomGateway.members![1]),
        findsOneWidget,
      );
    });

    testWidgets(
        'User 1 knows that user 2 has joined the room', (tester) async {});
    testWidgets(
        'Users can start the game when the room is full', (tester) async {});
  });
}
