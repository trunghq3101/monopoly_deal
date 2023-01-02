import 'package:equatable/equatable.dart';

mixin ServerPacket {}

class ClientPacket with EquatableMixin {
  ClientPacket({required this.sid});

  final String sid;
  @override
  List<Object?> get props => [sid];
}

enum PacketType {
  error,
  connected,
  createRoom,
  joinRoom,
  roomInfo,
}
