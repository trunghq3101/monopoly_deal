import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Room', () {
    testWidgets('User 1 can create a room and receive the room code',
        (tester) async {});
    testWidgets('User 1 sees themselves in the room', (tester) async {});
    testWidgets('User 2 can join the room using the correct room code',
        (tester) async {});
    testWidgets(
        'User 1 knows that user 2 has joined the room', (tester) async {});
    testWidgets(
        'Users can start the game when the room is full', (tester) async {});
  });
}
