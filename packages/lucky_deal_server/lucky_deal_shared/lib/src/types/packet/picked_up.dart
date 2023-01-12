import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class PickedUp with EquatableMixin, PacketData {
  PickedUp(this.playerId, this.cards);

  factory PickedUp.from(List<String> values) =>
      PickedUp(values[0], values.sublist(1).map((e) => int.parse(e)).toList());

  final String playerId;
  final List<int> cards;

  @override
  String encode() => "$playerId,${cards.join(",")}";

  @override
  List<Object?> get props => [playerId, cards];
}
