import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class RoomCreated with EquatableMixin, PacketData {
  RoomCreated(this.roomId);

  factory RoomCreated.from(List<String> values) => RoomCreated(values[0]);

  final String roomId;

  @override
  String encode() => roomId;

  @override
  List<Object?> get props => [roomId];
}
