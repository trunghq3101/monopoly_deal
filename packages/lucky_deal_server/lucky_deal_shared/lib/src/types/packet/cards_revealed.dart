import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class CardRevealed with EquatableMixin, PacketData {
  CardRevealed(this.cardIndex, this.cardId);

  factory CardRevealed.from(List<String> values) =>
      CardRevealed(int.parse(values[0]), int.parse(values[1]));

  final int cardIndex;
  final int cardId;

  @override
  String encode() => "$cardIndex,$cardId";

  @override
  List<Object?> get props => [cardIndex, cardId];
}
