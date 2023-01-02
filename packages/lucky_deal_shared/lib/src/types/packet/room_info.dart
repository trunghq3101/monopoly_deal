import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'packet.dart';

class RoomInfoPacket with EquatableMixin, PacketData {
  RoomInfoPacket({
    required this.roomId,
    required this.maxMembers,
    required this.memberIds,
  });

  factory RoomInfoPacket.from(String data) {
    final decoded = jsonDecode(data);
    return RoomInfoPacket(
      roomId: decoded['roomId'],
      maxMembers: decoded['maxMembers'],
      memberIds: decoded['memberIds'],
    );
  }

  @override
  String encode() {
    return jsonEncode({
      'roomId': roomId,
      'maxMembers': maxMembers,
      'memberIds': memberIds,
    });
  }

  final String roomId;
  final List<String> memberIds;
  final int maxMembers;

  @override
  List<Object?> get props => [roomId, memberIds, maxMembers];
}
