import 'dart:convert';

import 'packet.dart';

class WsDto {
  WsDto(this.event, this.data);

  factory WsDto.from(String raw) {
    final r = jsonDecode(raw);
    final typeIndex = r['event'];
    final type = PacketType.values[typeIndex];
    final decoded = type.decode(r['data']);
    return WsDto(type, decoded);
  }

  String encode() {
    return jsonEncode({
      'event': event.index,
      'data': data.encode(),
    });
  }

  final PacketType event;
  final PacketData data;
}

mixin PacketData {
  String encode();
}
