import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class MembersUpdated with EquatableMixin, PacketData {
  MembersUpdated(this.members);

  factory MembersUpdated.from(List<String> values) => MembersUpdated(values);

  final List<String> members;

  @override
  String encode() => members.join(",");

  @override
  List<Object?> get props => [members];
}
