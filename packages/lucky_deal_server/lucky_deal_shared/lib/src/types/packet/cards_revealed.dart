import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class CardsRevealed with EquatableMixin, PacketData {
  CardsRevealed(this.cardIds);

  factory CardsRevealed.from(List<String> values) =>
      CardsRevealed(values.map((e) => int.parse(e)).toList());

  final List<int> cardIds;

  @override
  String encode() => cardIds.join(",");

  @override
  List<Object?> get props => [cardIds];
}
