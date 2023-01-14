import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class PlayerId with EquatableMixin, PacketData {
  PlayerId(this.sid);

  factory PlayerId.from(List<String> values) => PlayerId(values[0]);

  final String sid;

  @override
  String encode() => sid;

  @override
  List<Object?> get props => [sid];
}
