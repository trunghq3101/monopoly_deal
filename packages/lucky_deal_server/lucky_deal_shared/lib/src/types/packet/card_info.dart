import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class CardInfo with EquatableMixin, PacketData {
  CardInfo(this.cardIndex);

  factory CardInfo.from(List<String> values) {
    return CardInfo(int.parse(values[0]));
  }

  @override
  String encode() {
    return "$cardIndex";
  }

  final int cardIndex;

  @override
  List<Object?> get props => [cardIndex];
}
