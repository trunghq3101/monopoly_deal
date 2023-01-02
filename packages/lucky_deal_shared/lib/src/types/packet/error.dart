import 'package:equatable/equatable.dart';

import 'packet.dart';

enum PacketErrorType { roomNotExist, alreadyInRoom }

class ErrorPacket with EquatableMixin, ServerPacket {
  ErrorPacket(this.type);

  factory ErrorPacket.from(Object? data) {
    final errorCodeIndex = int.parse(data as String);
    return ErrorPacket(PacketErrorType.values[errorCodeIndex]);
  }

  String encode() {
    return "${type.index}";
  }

  final PacketErrorType type;

  @override
  List<Object?> get props => [type];
}
