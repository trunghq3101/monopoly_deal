import 'dart:async';

import 'package:dart_frog/dart_frog.dart';

class RoomMembersManager {
  RoomMembersManager({List<String>? initial}) : _membersList = initial ?? [];
  late Stream<List<String>> members = _membersController.stream;
  late Stream<String> newJoined = _newJoinedController.stream;
  final _membersController = StreamController<List<String>>.broadcast();
  final _newJoinedController = StreamController<String>.broadcast();
  late final List<String> _membersList;

  void join(String sid) {
    _newJoinedController.add(sid);
    _membersList.add(sid);
    _membersController.add(_membersList);
  }
}

class RoomsManager {
  final Map<String, RoomMembersManager> _rooms = {};

  RoomMembersManager findById(String roomId) {
    if (!_rooms.containsKey(roomId)) throw StateError('Room $roomId not exist');
    return _rooms.putIfAbsent(roomId, RoomMembersManager.new);
  }

  RoomMembersManager create(String roomId) {
    if (_rooms.containsKey(roomId)) throw StateError('Room $roomId existed');
    return _rooms.putIfAbsent(roomId, RoomMembersManager.new);
  }
}

final roomsManager = RoomsManager();
final roomsManagerProvider = provider<RoomsManager>((_) => roomsManager);
