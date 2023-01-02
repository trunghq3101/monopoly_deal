import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'packet.dart';

class ConnectedPacket with EquatableMixin, PacketData {
  ConnectedPacket(this.sid);

  factory ConnectedPacket.from(String data) {
    final decoded = jsonDecode(data);
    return ConnectedPacket(decoded['sid']);
  }

  @override
  String encode() {
    return jsonEncode({'sid': sid});
  }

  final String sid;

  @override
  List<Object?> get props => [sid];
}
