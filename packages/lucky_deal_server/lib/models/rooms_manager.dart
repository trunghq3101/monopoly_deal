import 'package:lucky_deal_server/models/models.dart';

class RoomsManager {
  final Map<String, RoomMembersManager> _rooms = {};
  final Map<String, String> _memberToRoom = {};

  String get lastRoomId => _rooms.keys.last;

  RoomMembersManager findById(String roomId) {
    if (!_rooms.containsKey(roomId)) throw StateError('Room $roomId not exist');
    return _rooms.putIfAbsent(roomId, RoomMembersManager.new);
  }

  RoomMembersManager create(String roomId) {
    if (_rooms.containsKey(roomId)) throw StateError('Room $roomId existed');
    final newRoom = RoomMembersManager()
      ..newJoined.listen((sid) {
        if (_memberToRoom.containsKey(sid)) {
          throw StateError('$sid is already in room ${_memberToRoom[sid]}');
        }
        _memberToRoom.putIfAbsent(sid, () => roomId);
      })
      ..newLeft.listen(_memberToRoom.remove);
    return _rooms.putIfAbsent(roomId, () => newRoom);
  }

  RoomMembersManager? findByMember(String memberId) {
    if (!_memberToRoom.containsKey(memberId)) return null;
    final roomId = _memberToRoom[memberId];
    if (!_rooms.containsKey(roomId)) {
      throw StateError(
        'Unsynced roomId $roomId between _memberToRoom and _rooms',
      );
    }
    return _rooms[roomId];
  }
}
