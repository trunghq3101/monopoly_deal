import 'package:equatable/equatable.dart';

enum PacketType {
  error,
  connected,
  createRoom,
  createdRoom,
  joinRoom,
  joinedRoom,
}

enum ErrorCode { roomNotExist }

mixin ServerPacket {}

class ErrorPacket with EquatableMixin, ServerPacket {
  ErrorPacket(this.errorCode);

  factory ErrorPacket.from(Object? data) {
    final errorCodeIndex = int.parse(data as String);
    return ErrorPacket(ErrorCode.values[errorCodeIndex]);
  }

  final ErrorCode errorCode;

  @override
  List<Object?> get props => [errorCode];
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

class CreatedRoomPacket with EquatableMixin, ServerPacket {
  CreatedRoomPacket({required this.roomId, required this.memberIds});

  factory CreatedRoomPacket.from(Object? data) {
    final parts = (data as String).split(",");
    return CreatedRoomPacket(
      roomId: parts[0],
      memberIds: parts.sublist(1),
    );
  }

  final String roomId;
  final List<String> memberIds;

  @override
  List<Object?> get props => [roomId, memberIds];
}

class JoinedRoomPacket with EquatableMixin, ServerPacket {
  JoinedRoomPacket({required this.roomId, required this.memberIds});

  factory JoinedRoomPacket.from(Object? data) {
    final parts = (data as String).split(",");
    return JoinedRoomPacket(
      roomId: parts[0],
      memberIds: parts.sublist(1),
    );
  }

  final String roomId;
  final List<String> memberIds;

  @override
  List<Object?> get props => [roomId, memberIds];
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
