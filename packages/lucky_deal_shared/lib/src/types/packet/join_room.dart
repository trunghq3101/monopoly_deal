import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'packet.dart';

class JoinRoomPacket with EquatableMixin, PacketData {
  JoinRoomPacket(this.sid, this.roomId);

  factory JoinRoomPacket.from(String data) {
    final decoded = jsonDecode(data);
    return JoinRoomPacket(decoded['sid'], decoded['roomId']);
  }

  @override
  String encode() {
    return jsonEncode({'sid': sid, 'roomId': roomId});
  }

  final String sid;
  final String roomId;

  @override
  List<Object?> get props => [sid, roomId];
}
