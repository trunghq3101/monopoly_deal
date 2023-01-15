import 'dart:async';

import 'package:lucky_deal_server/models/models.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group(
    'RoomsManager',
    () {
      RoomsManager manager;

      test('User can create a new RoomMembersManager', () {
        manager = RoomsManager();
        const roomId = '1';
        expect(manager.create(roomId), isA<RoomMembersManager>());
      });

      test('User receives an error when trying to create using the same id',
          () {
        manager = RoomsManager();
        const roomId = '1';
        manager.create(roomId);
        expect(() => manager.create(roomId), throwsStateError);
      });

      test('User can request an existing RoomMembersManager by id', () {
        manager = RoomsManager();
        const roomId = '1';
        manager.create(roomId);
        expect(manager.findById(roomId), isA<RoomMembersManager>());
      });

      test('User receives an error when requesting a non-existing room', () {
        manager = RoomsManager();
        const roomId = '1';
        expect(() => manager.findById(roomId), throwsStateError);
      });

      test('User receives the same RoomMembersManager created before', () {
        manager = RoomsManager();
        const roomId = '1';
        expect(manager.create(roomId), manager.findById(roomId));
      });

      test('User can find a room that a user is a member of', () async {
        manager = RoomsManager();
        const roomId = '1';
        const memberId = 'u1';
        final room = manager.create(roomId)..join(memberId);
        await testDelayZero();
        expect(manager.findByMember(memberId), room);
      });

      test('User receives an error when joining more than 1 room', () async {
        await runZonedGuarded(
          () async {
            manager = RoomsManager();
            const roomId = '1';
            const roomId2 = '2';
            const memberId = 'u1';
            manager.create(roomId).join(memberId);
            await testDelayZero();
            manager.create(roomId2).join(memberId);
          },
          expectAsync2((e, s) {
            expect(e, isA<StateError>());
          }),
        );
      });
    },
    timeout: Timeout.parse('2s'),
  );
}
