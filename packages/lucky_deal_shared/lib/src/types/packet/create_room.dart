import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'packet.dart';

class CreateRoomPacket with EquatableMixin, PacketData {
  CreateRoomPacket(this.sid);

  factory CreateRoomPacket.from(String data) {
    final decoded = jsonDecode(data);
    return CreateRoomPacket(decoded['sid']);
  }

  @override
  String encode() {
    return jsonEncode({'sid': sid});
  }

  final String sid;

  @override
  List<Object?> get props => [sid];
}
