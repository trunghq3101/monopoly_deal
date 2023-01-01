import 'package:equatable/equatable.dart';

enum PacketType {
  error,
  connected,
  createRoom,
  joinRoom,
  roomInfo,
}

enum PacketErrorType { roomNotExist, alreadyInRoom }

mixin ServerPacket {}

class ErrorPacket with EquatableMixin, ServerPacket {
  ErrorPacket(this.type);

  factory ErrorPacket.from(Object? data) {
    final errorCodeIndex = int.parse(data as String);
    return ErrorPacket(PacketErrorType.values[errorCodeIndex]);
  }

  final PacketErrorType type;

  @override
  List<Object?> get props => [type];
}

class ConnectedPacket with EquatableMixin, ServerPacket {
  ConnectedPacket({required this.sid});

  factory ConnectedPacket.from(Object? data) {
    return ConnectedPacket(sid: data as String);
  }

  final String sid;

  @override
  List<Object?> get props => [sid];
}

class RoomInfoPacket with EquatableMixin, ServerPacket {
  RoomInfoPacket({
    required this.roomId,
    required this.maxMembers,
    required this.memberIds,
  });

  factory RoomInfoPacket.from(Object? data) {
    final parts = (data as String).split(",");
    return RoomInfoPacket(
      roomId: parts[0],
      maxMembers: int.parse(parts[1]),
      memberIds: parts.sublist(2),
    );
  }

  final String roomId;
  final List<String> memberIds;
  final int maxMembers;

  @override
  List<Object?> get props => [roomId, memberIds, maxMembers];
}

class ClientPacket with EquatableMixin {
  ClientPacket({required this.sid});

  final String sid;
  @override
  List<Object?> get props => [sid];
}

class CreateRoomPacket extends ClientPacket with EquatableMixin {
  CreateRoomPacket({required super.sid});
}

class JoinRoomPacket extends ClientPacket with EquatableMixin {
  JoinRoomPacket({
    required super.sid,
    required this.roomId,
  });

  final String roomId;

  @override
  List<Object?> get props => [...super.props, roomId];
}
