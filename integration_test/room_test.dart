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
        (tester) async {});

    testWidgets(
        'User 1 knows that user 2 has joined the room', (tester) async {});
    testWidgets(
        'Users can start the game when the room is full', (tester) async {});
  });
}
