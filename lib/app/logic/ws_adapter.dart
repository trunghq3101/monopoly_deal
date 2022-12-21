import 'dart:convert';

import 'package:monopoly_deal/app/app.dart';

class WsDto {
  final String event;
  final String? data;

  WsDto(this.event, this.data);

  factory WsDto.from(Map<String, dynamic> json) =>
      WsDto(json['event']!, json['data']);

  Map<String, dynamic> toJson() {
    return {'event': event, 'data': data};
  }
}

class WsAdapter {
  ServerPacket decode(String raw) {
    final dto = WsDto.from(jsonDecode(raw));
    final type = PacketType.values.firstWhere((e) => dto.event == e.name);
    switch (type) {
      case PacketType.connected:
        return ConnectedPacket.from(dto.data);
      case PacketType.connectedRoom:
        return ConnectedRoomPacket.from(dto.data);
      default:
        throw ArgumentError('Packet type is invalid');
    }
  }

  String encode(ClientPacket packet) {
    WsDto wsDto;
    if (packet is CreateRoomPacket) {
      wsDto = WsDto(
        PacketType.createRoom.name,
        packet.sid,
      );
    } else if (packet is JoinRoomPacket) {
      wsDto = WsDto(
        PacketType.joinRoom.name,
        '${packet.sid},${packet.roomId}',
      );
    } else {
      throw ArgumentError('Packet is invalid');
    }
    return jsonEncode(wsDto.toJson());
  }
}
