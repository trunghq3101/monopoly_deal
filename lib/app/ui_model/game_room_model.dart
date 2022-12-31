import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart';

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

  @override
  void dispose() {
    wsGateway.removeListener(_getRoomInfo);
    super.dispose();
  }

  void _getRoomInfo() {
    if (wsGateway.sid == null) {
      roomId = null;
      maxMembers = null;
      loading = false;
      members.clear();
      notifyListeners();
    }
    final packet = wsGateway.serverPacket;
    if (wsGateway.connectionState is Connecting ||
        wsGateway.connectionState is Reconnecting) {
      loading = true;
      notifyListeners();
    }
    if (wsGateway.connectionState is Disconnected ||
        packet is ErrorPacket ||
        packet is RoomInfoPacket) {
      loading = false;
      notifyListeners();
    }
    if (packet is RoomInfoPacket) {
      roomId = packet.roomId;
      members = packet.memberIds;
      maxMembers = packet.maxMembers;
      notifyListeners();
    }
  }
}
