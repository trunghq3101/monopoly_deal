import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class MemberLeft with EquatableMixin, PacketData {
  MemberLeft(this.sid);

  factory MemberLeft.from(List<String> values) => MemberLeft(values[0]);

  final String sid;

  @override
  String encode() => sid;

  @override
  List<Object?> get props => [sid];
}
