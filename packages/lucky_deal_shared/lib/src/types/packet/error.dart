import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'packet.dart';

enum PacketErrorType { roomNotExist, alreadyInRoom }

class ErrorPacket with EquatableMixin, PacketData {
  ErrorPacket(this.type);

  factory ErrorPacket.from(String data) {
    final decoded = jsonDecode(data);
    return ErrorPacket(decoded['code']);
  }

  @override
  String encode() {
    return jsonEncode({'code': type});
  }

  final PacketErrorType type;

  @override
  List<Object?> get props => [type];
}
