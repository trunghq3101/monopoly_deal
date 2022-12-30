import 'dart:convert';

import 'package:collection/collection.dart';
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
    final type = PacketType.values.firstWhereOrNull((e) => dto.event == e.name);
    switch (type) {
      case PacketType.error:
        return ErrorPacket.from(dto.data);
      case PacketType.connected:
        return ConnectedPacket.from(dto.data);
      case PacketType.roomInfo:
        return RoomInfo.from(dto.data);
      default:
        throw UnimplementedError(
            'Unimplemented decoder for this type: ${dto.event}');
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
