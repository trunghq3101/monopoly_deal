import 'package:equatable/equatable.dart';

import 'packet.dart';

class JoinRoomPacket extends ClientPacket with EquatableMixin {
  JoinRoomPacket({
    required super.sid,
    required this.roomId,
  });

  final String roomId;

  @override
  List<Object?> get props => [...super.props, roomId];
}
