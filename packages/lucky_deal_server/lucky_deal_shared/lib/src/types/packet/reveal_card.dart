import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class RevealCard with EquatableMixin, PacketData {
  RevealCard(this.cardIndex);

  factory RevealCard.from(List<String> values) {
    return RevealCard(int.parse(values[0]));
  }

  @override
  String encode() {
    return "$cardIndex";
  }

  final int cardIndex;

  @override
  List<Object?> get props => [cardIndex];
}
