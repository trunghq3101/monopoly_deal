import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';

class GameRoomModel extends InheritedNotifier<GameRoomNotifier> {
  const GameRoomModel({
    super.key,
    required super.child,
    super.notifier,
  });

  static GameRoomNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GameRoomModel>()!
        .notifier!;
  }
}

class GameRoomNotifier extends ChangeNotifier {
  WsConnection? _wsConnection;
  int? roomId;
  List<String> members = [];

  void creatRoom() {
    _wsConnection = WsConnection();
    _wsConnection?.createRoom();
    _wsConnection?.messageStream.listen((event) {
      if (event is CreatedRoomPacket) {
        roomId = (event).roomId;
        members = (event).memberIds;
        notifyListeners();
      }
    });
  }

  void joinRoom(int roomId) {
    _wsConnection = WsConnection();
    _wsConnection?.joinRoom(roomId);
    _wsConnection?.messageStream.listen((event) {
      if (event is JoinedRoomPacket) {
        this.roomId = (event).roomId;
        members = (event).memberIds;
        notifyListeners();
      }
    });
  }

  void closeWsConnection() {
    _wsConnection?.close();
    _wsConnection = null;
    roomId = null;
  }
}
