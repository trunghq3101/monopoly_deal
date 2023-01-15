import 'package:lucky_deal_server/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Room broadcast',
    () {
      test('Only member can send broadcast messages', () {
        expect(
          () => RoomMembersManager().broadcast('sid', 'msg'),
          throwsArgumentError,
        );
        RoomMembersManager(initial: ['sid']).broadcast('sid', 'msg');
      });

      test('Members can receive broadcast messages', () {
        final room = RoomMembersManager(initial: ['sid']);
        expectLater(room.messages, emits('msg'));
        room.broadcast('sid', 'msg');
      });
    },
    timeout: Timeout.parse('2s'),
  );
}
