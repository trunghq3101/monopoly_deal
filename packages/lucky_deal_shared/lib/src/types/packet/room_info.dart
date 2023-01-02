import 'package:equatable/equatable.dart';

import 'packet.dart';

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

  String encode() {
    return "$roomId,$maxMembers,${memberIds.join(",")}";
  }

  final String roomId;
  final List<String> memberIds;
  final int maxMembers;

  @override
  List<Object?> get props => [roomId, memberIds, maxMembers];
}
