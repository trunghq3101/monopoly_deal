import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class JoinedRoom with EquatableMixin, PacketData {
  JoinedRoom(this.roomId);

  factory JoinedRoom.from(List<String> values) => JoinedRoom(values[0]);

  final String roomId;

  @override
  String encode() => roomId;

  @override
  List<Object?> get props => [roomId];
}
