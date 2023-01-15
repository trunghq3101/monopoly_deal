import 'dart:async';

import 'package:lucky_deal_server/models/models.dart';

class RoomMembersManager {
  RoomMembersManager({List<String>? initial, GameMaster? gameMaster})
      : _membersList = initial ?? [],
        gameMaster = gameMaster ?? GameMaster()
          ..shuffle();
  late Stream<List<String>> members = _membersController.stream;
  late Stream<String> newJoined = _newJoinedController.stream;
  late Stream<String> newLeft = _newLeftController.stream;
  late Stream<String> messages = _messagesController.stream;
  final _membersController = StreamController<List<String>>.broadcast();
  final _newJoinedController = StreamController<String>.broadcast();
  final _newLeftController = StreamController<String>.broadcast();
  final _messagesController = StreamController<String>.broadcast();
  late final List<String> _membersList;
  late final GameMaster gameMaster;

  void join(String sid) {
    _newJoinedController.add(sid);
    _membersList.add(sid);
    _membersController.add(_membersList);
  }

  void leave(String sid) {
    _newLeftController.add(sid);
    _membersList.remove(sid);
    _membersController.add(_membersList);
  }

  int memberIndex(String sid) {
    if (!_membersList.contains(sid)) {
      throw ArgumentError('$sid is not a member of this room');
    }
    return _membersList.indexOf(sid);
  }

  void broadcast(String sender, String message) {
    if (!_membersList.contains(sender)) {
      throw ArgumentError('$sender is not a member of this room');
    }
    _messagesController.add(message);
  }
}
