import 'package:lucky_deal_server/providers/providers.dart';
import 'package:test/test.dart';

void main() {
  group(
    'RoomMembersManager',
    () {
      RoomMembersManager manager;

      test(
        'Notify that member list has been updated',
        () {
          manager = RoomMembersManager(initial: ['user1']);
          const sid = 'user2';
          expectLater(manager.members, emits(['user1', 'user2']));
          manager.join(sid);
        },
      );

      test(
        'Notify that a user has been joined',
        () {
          manager = RoomMembersManager();
          const sid = 'user1';
          expectLater(manager.newJoined, emits('user1'));
          manager.join(sid);
        },
      );
    },
    timeout: Timeout.parse('2s'),
  );
}
