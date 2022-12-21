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
        adapter.decode("""{"event": "connectedRoom", "data": "1,id1,id2"}"""),
        ConnectedRoomPacket(roomId: 1, memberIds: ['id1', 'id2']),
      );
    });

    test('encode', () {
      expect(
        adapter.encode(CreateRoomPacket(sid: 'sid')),
        """{"event":"createRoom","data":"sid"}""",
      );
      expect(
        adapter.encode(JoinRoomPacket(sid: 'sid', roomId: 1)),
        """{"event":"joinRoom","data":"sid,1"}""",
      );
    });
  });
}
