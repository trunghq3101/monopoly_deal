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
  String? roomId;
  List<String> members = [];
  bool loading = false;

  GameRoomNotifier() {
    _getRoomInfo();
    wsGateway.addListener(_getRoomInfo);
  }

  void waitingForNewState() {
    loading = true;
  }

  @override
  void dispose() {
    wsGateway.removeListener(_getRoomInfo);
    super.dispose();
  }

  void _getRoomInfo() {
    loading = false;
    if (wsGateway.sid == null) {
      roomId = null;
      members.clear();
    }
    final packet = wsGateway.serverPacket;
    if (packet is CreatedRoomPacket) {
      roomId = packet.roomId;
      members = packet.memberIds;
      notifyListeners();
    } else if (packet is JoinedRoomPacket) {
      roomId = packet.roomId;
      members = packet.memberIds;
      notifyListeners();
    }
  }
}
