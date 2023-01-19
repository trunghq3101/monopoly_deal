import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class CreateRoom with EquatableMixin, PacketData {
  CreateRoom(this.playersAmount);

  factory CreateRoom.from(List<String> values) =>
      CreateRoom(int.parse(values[0]));

  @override
  String encode() {
    return "$playersAmount";
  }

  final int playersAmount;

  @override
  List<Object?> get props => [playersAmount];
}
