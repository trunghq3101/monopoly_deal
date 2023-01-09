import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/models/models.dart';

class RoomMembersManager {
  RoomMembersManager({List<String>? initial, Deck? deck})
      : _membersList = initial ?? [],
        _deck = deck ?? Deck()
          ..shuffle();
  late Stream<List<String>> members = _membersController.stream;
  late Stream<String> newJoined = _newJoinedController.stream;
  late Stream<String> messages = _messagesController.stream;
  final _membersController = StreamController<List<String>>.broadcast();
  final _newJoinedController = StreamController<String>.broadcast();
  final _messagesController = StreamController<String>.broadcast();
  late final List<String> _membersList;
  late final Deck _deck;

  void join(String sid) {
    _newJoinedController.add(sid);
    _membersList.add(sid);
    _membersController.add(_membersList);
  }

  void broadcast(String sender, String message) {
    if (!_membersList.contains(sender)) {
      throw ArgumentError('$sender is not a member of this room');
    }
    _messagesController.add(message);
  }

  List<int> cardsToBeDealed(String sid) {
    if (!_membersList.contains(sid)) {
      throw ArgumentError('$sid is not a member of this room');
    }
    return _deck.toBeDealed(_membersList.indexOf(sid), _membersList.length);
  }
}

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
    final newRoom = RoomMembersManager();
    newRoom.newJoined.listen((sid) {
      if (_memberToRoom.containsKey(sid)) {
        throw StateError('$sid is already in room ${_memberToRoom[sid]}');
      }
      _memberToRoom.putIfAbsent(sid, () => roomId);
    });
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
    return _rooms[_memberToRoom[memberId]];
  }
}

final roomsManager = RoomsManager();
final roomsManagerProvider = provider<RoomsManager>((_) => roomsManager);
