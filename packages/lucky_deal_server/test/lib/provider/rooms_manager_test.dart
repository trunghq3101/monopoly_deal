import 'package:lucky_deal_server/providers/providers.dart';
import 'package:test/test.dart';

void main() {
  group('RoomsManager', () {
    RoomsManager manager;

    test('User can create a new RoomMembersManager', () {
      manager = RoomsManager();
      const roomId = '1';
      expect(manager.create(roomId), isA<RoomMembersManager>());
    });

    test('User receives an error when trying to create using the same id', () {
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
  });
}
