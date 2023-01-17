import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class RoomInfo with EquatableMixin, PacketData {
  RoomInfo(this.roomId, this.playerAmount);

  factory RoomInfo.from(List<String> values) =>
      RoomInfo(values[0], int.parse(values[1]));

  final String roomId;
  final int playerAmount;

  @override
  String encode() => '$roomId,$playerAmount';

  @override
  List<Object?> get props => [roomId, playerAmount];
}
