import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart';

class RoomGateway extends ChangeNotifier {
  RoomGateway({WsManager? wsManager}) : _wsManager = wsManager ?? WsManager();

  String? roomId;
  List<String>? members;
  late Stream<WsDto> gameEvents = _gameEvents.stream;
  bool get isFull => members?.length == 2;
  final WsManager _wsManager;
  bool _bound = false;
  final StreamController<WsDto> _gameEvents = StreamController.broadcast();

  Future<WebSocket> get socket async {
    final ws = await _wsManager.connection();
    if (!_bound) {
      _bound = true;
      ws.connection.listen((event) {
        if (event is Disconnected) {
          roomId = null;
          members = null;
        }
      });
      ws.messages.listen(
        (msg) {
          final wsDto = WsDto.from(msg);
          final event = wsDto.event;
          final data = wsDto.data;
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
            case PacketType.gameStarted:
            case PacketType.cardsRevealed:
              _gameEvents.add(wsDto);
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

  Future<void> startGame() async {
    (await socket).send(WsDto(PacketType.startGame, EmptyPacket()).encode());
  }

  Future<void> revealCard(int index) async {
    (await socket)
        .send(WsDto(PacketType.revealCard, RevealCard(index)).encode());
  }

  Future<void> disconnect() async {
    _wsManager.disconnect();
  }
}
