import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

enum PacketErrorType { general, roomNotExist, alreadyInRoom }

class ErrorPacket with EquatableMixin, PacketData {
  ErrorPacket(this.type);

  factory ErrorPacket.from(List<String> values) {
    return ErrorPacket(
      PacketErrorType.values.firstWhere((e) => e.name == values[0]),
    );
  }

  @override
  String encode() {
    return type.name;
  }

  final PacketErrorType type;

  @override
  List<Object?> get props => [type];
}
