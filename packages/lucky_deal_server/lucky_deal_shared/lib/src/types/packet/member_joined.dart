import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class MemberJoined with EquatableMixin, PacketData {
  MemberJoined(this.sid);

  factory MemberJoined.from(List<String> values) => MemberJoined(values[0]);

  final String sid;

  @override
  String encode() => sid;

  @override
  List<Object?> get props => [sid];
}
