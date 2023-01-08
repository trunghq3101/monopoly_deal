import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/main_app.dart';

void main() {
  group('Room UI', () {
    testWidgets(
        'User 1 can tap a button to create a room and see the room code',
        (tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final button = find.text('Create room');
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text('roomId'), findsOneWidget);
    });

    testWidgets('User 1 sees themselves in the room', (tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final button = find.text('Create room');
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(
        find.byWidgetPredicate(
            (widget) => widget is Member && widget.id != null),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
            (widget) => widget is Member && widget.id == 'user1'),
        findsOneWidget,
      );
    });
  });
}
