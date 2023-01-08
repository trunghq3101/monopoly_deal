import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class EmptyPacket with EquatableMixin, PacketData {
  EmptyPacket();

  factory EmptyPacket.from(List<String> values) => EmptyPacket();

  @override
  String encode() {
    return '';
  }

  @override
  List<Object?> get props => [];
}
