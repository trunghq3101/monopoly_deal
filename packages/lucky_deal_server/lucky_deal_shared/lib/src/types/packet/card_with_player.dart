import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class CardWithPlayer with EquatableMixin, PacketData {
  CardWithPlayer(this.playerId, this.cardIndex);

  factory CardWithPlayer.from(List<String> values) {
    return CardWithPlayer(values[0], int.parse(values[1]));
  }

  @override
  String encode() {
    return "$playerId,$cardIndex";
  }

  final String playerId;
  final int cardIndex;

  @override
  List<Object?> get props => [playerId, cardIndex];
}
