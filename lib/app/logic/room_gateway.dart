import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart';

class RoomGateway extends ChangeNotifier {
  RoomGateway({WsManager? wsManager}) : _wsManager = wsManager ?? WsManager();

  String? roomId;
  List<String>? members;
  bool get isFull => members?.length == 2;
  final WsManager _wsManager;
  bool _bound = false;

  Future<WebSocket> get socket async {
    final ws = await _wsManager.connection();
    if (!_bound) {
      _bound = true;
      ws.messages.listen(
        (msg) {
          final event = WsDto.from(msg).event;
          final data = WsDto.from(msg).data;
          switch (event) {
            case PacketType.roomCreated:
              roomId = (data as RoomCreated).roomId;
              notifyListeners();
              break;
            case PacketType.joinedRoom:
              roomId = (data as JoinedRoom).roomId;
              notifyListeners();
              break;
            case PacketType.membersUpdated:
              members = (data as MembersUpdated).members;
              notifyListeners();
              break;
            default:
          }
        },
        onDone: () {
          _bound = false;
        },
      );
    }
    return ws;
  }

  Future<void> createRoom() async {
    (await socket).send(WsDto(PacketType.createRoom, EmptyPacket()).encode());
  }

  Future<void> joinRoom(String roomId) async {
    (await socket).send(WsDto(PacketType.joinRoom, JoinRoom(roomId)).encode());
  }
}
