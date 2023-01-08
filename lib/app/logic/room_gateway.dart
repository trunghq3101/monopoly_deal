import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart';

class RoomGateway extends ChangeNotifier {
  RoomGateway({WsManager? wsManager}) : _wsManager = wsManager ?? WsManager();

  String? roomId;
  List<String>? members;
  final WsManager _wsManager;
  bool _bound = false;

  Future<WebSocket> get socket async {
    final ws = await _wsManager.connection();
    if (!_bound) {
      _bound = true;
      ws.messages.listen(
        (event) {
          final packet = WsDto.from(event).data;
          if (packet is RoomCreated) {
            roomId = packet.roomId;
            notifyListeners();
          }
          if (packet is MembersUpdated) {
            members = packet.members;
            notifyListeners();
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
