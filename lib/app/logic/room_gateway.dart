import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws_client;

class RoomGateway extends ChangeNotifier {
  RoomGateway({WsManager? wsManager}) : _wsManager = wsManager ?? WsManager();

  String? sid;
  String? roomId;
  List<String>? members;
  String? turnId;
  int? playerAmount;
  late Stream<WsDto> gameEvents = _gameEvents.stream;
  bool get isFull => members?.length == playerAmount;
  final WsManager _wsManager;
  bool _bound = false;
  final StreamController<WsDto> _gameEvents = StreamController.broadcast();

  Future<ws_client.WebSocket> get socket async {
    final ws = await _wsManager.connection();
    if (!_bound) {
      _bound = true;
      ws.send(WsDto(PacketType.ackConnection, EmptyPacket()).encode());
      ws.connection.listen((event) {
        if (event is ws_client.Disconnected) {
          sid = null;
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
            case PacketType.connected:
              sid = (data as Connected).sid;
              notifyListeners();
              break;
            case PacketType.roomCreated:
              roomId = (data as RoomInfo).roomId;
              playerAmount = data.playerAmount;
              notifyListeners();
              break;
            case PacketType.joinedRoom:
              roomId = (data as RoomInfo).roomId;
              playerAmount = data.playerAmount;
              notifyListeners();
              break;
            case PacketType.membersUpdated:
              members = (data as MembersUpdated).members;
              notifyListeners();
              break;
            case PacketType.turnPassed:
              turnId = (data as PlayerId).sid;
              _gameEvents.add(wsDto);
              notifyListeners();
              break;
            case PacketType.gameStarted:
            case PacketType.cardRevealed:
            case PacketType.pickedUp:
              _gameEvents.add(wsDto);
              notifyListeners();
              break;
            case PacketType.cardPreviewed:
            case PacketType.cardUnpreviewed:
              if ((wsDto.data as CardWithPlayer).playerId == sid) return;
              _gameEvents.add(wsDto);
              notifyListeners();
              break;
            case PacketType.cardPlayed:
              if ((wsDto.data as CardInfoWithPlayer).playerId == sid) return;
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

  int get myIndex {
    if (members == null || sid == null) {
      throw StateError('Missing room members or sid data');
    }
    return members!.indexOf(sid!);
  }

  int relativePlayerIndex(int playerIndex) {
    return playerIndex > myIndex
        ? playerIndex - myIndex - 1
        : ((playerIndex - myIndex) + playerAmount! - 1);
  }

  bool get isMyTurn => turnId != null && turnId == sid;

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

  int playerIndexOf(String playerId) {
    if (members == null) {
      throw StateError('Missing room members or sid data');
    }
    return members!.indexOf(playerId);
  }

  Future<void> pickUp() async {
    (await socket).send(WsDto(PacketType.pickUp, EmptyPacket()).encode());
  }

  Future<void> sendCardEvent(PacketType type, int cardIndex) async {
    (await socket).send(WsDto(type, CardInfo(cardIndex)).encode());
  }

  Future<void> endTurn() async {
    (await socket).send(WsDto(PacketType.passTurn, EmptyPacket()).encode());
  }
}
