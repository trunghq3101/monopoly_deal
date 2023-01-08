import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class JoinRoom with EquatableMixin, PacketData {
  JoinRoom(this.roomId);

  factory JoinRoom.from(List<String> values) {
    return JoinRoom(values[0]);
  }

  @override
  String encode() {
    return roomId;
  }

  final String roomId;

  @override
  List<Object?> get props => [roomId];
}
