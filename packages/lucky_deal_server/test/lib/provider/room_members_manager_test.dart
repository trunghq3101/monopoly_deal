import 'dart:async';

import 'package:lucky_deal_server/providers/providers.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group(
    'RoomMembersManager',
    () {
      RoomMembersManager manager;

      test(
        'Notify that member list has been updated',
        () async {
          manager = RoomMembersManager(initial: ['user1']);
          const sid = 'user2';
          unawaited(
            expectLater(
              manager.members,
              emitsInOrder([
                ['user1', 'user2'],
                ['user1']
              ]),
            ),
          );
          manager.join(sid);
          await testDelay();
          manager.leave(sid);
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

      test(
        'Notify that a user has been left',
        () {
          manager = RoomMembersManager();
          const sid = 'user1';
          manager.join(sid);
          expectLater(manager.newLeft, emits('user1'));
          manager.leave(sid);
        },
      );
    },
    timeout: Timeout.parse('2s'),
  );
}
