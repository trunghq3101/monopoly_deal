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
  int? maxMembers;
  bool get isFull => maxMembers == members.length;
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
      maxMembers = null;
      members.clear();
    }
    final packet = wsGateway.serverPacket;
    if (packet is RoomInfoPacket) {
      roomId = packet.roomId;
      members = packet.memberIds;
      maxMembers = packet.maxMembers;
      notifyListeners();
    }
  }
}
