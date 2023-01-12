import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class Connected with EquatableMixin, PacketData {
  Connected(this.sid);

  factory Connected.from(List<String> values) => Connected(values[0]);

  final String sid;

  @override
  String encode() => sid;

  @override
  List<Object?> get props => [sid];
}
