import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class JoinRoomPacket with EquatableMixin, PacketData {
  JoinRoomPacket(this.roomId);

  factory JoinRoomPacket.from(List<String> values) {
    return JoinRoomPacket(values[0]);
  }

  @override
  String encode() {
    return roomId;
  }

  final String roomId;

  @override
  List<Object?> get props => [roomId];
}
