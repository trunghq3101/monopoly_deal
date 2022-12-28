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

  GameRoomNotifier() {
    wsGateway.addListener(_listener);
  }

  @override
  void dispose() {
    wsGateway.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
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
