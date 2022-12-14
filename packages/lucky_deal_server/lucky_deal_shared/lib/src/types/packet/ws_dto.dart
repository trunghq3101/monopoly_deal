import 'package:equatable/equatable.dart';

import 'packet.dart';

class WsDto with EquatableMixin {
  WsDto(this.event, this.data);

  factory WsDto.from(String raw) {
    final values = raw.split(",");
    final typeIndex = int.parse(values[0]);
    final type = PacketType.values[typeIndex];
    final decoded = type.decode(values.sublist(1));
    return WsDto(type, decoded);
  }

  String encode() {
    return "${event.index},${data.encode()}";
  }

  final PacketType event;
  final PacketData data;

  @override
  List<Object?> get props => [event, data];
}

mixin PacketData {
  String encode();
}
