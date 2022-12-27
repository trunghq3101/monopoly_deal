import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/app/app.dart';

void main() {
  group('WsAdapter', () {
    late WsAdapter adapter;

    setUp(() {
      adapter = WsAdapter();
    });

    test('decode', () {
      expect(
        adapter.decode("""{"event": "connected", "data": "abc"}"""),
        ConnectedPacket(sid: 'abc'),
      );
      expect(
        adapter.decode("""{"event": "createdRoom", "data": "room,id1,id2"}"""),
        CreatedRoomPacket(roomId: 'room', memberIds: ['id1', 'id2']),
      );
      expect(
        adapter.decode("""{"event": "joinedRoom", "data": "room,id1,id2"}"""),
        JoinedRoomPacket(roomId: 'room', memberIds: ['id1', 'id2']),
      );
    });

    test('encode', () {
      expect(
        adapter.encode(CreateRoomPacket(sid: 'sid')),
        """{"event":"createRoom","data":"sid"}""",
      );
      expect(
        adapter.encode(JoinRoomPacket(sid: 'sid', roomId: 'room')),
        """{"event":"joinRoom","data":"sid,room"}""",
      );
    });
  });
}
