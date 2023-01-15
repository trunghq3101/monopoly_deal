import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class CardInfoWithPlayer with EquatableMixin, PacketData {
  CardInfoWithPlayer(this.playerId, this.cardIndex, this.cardId);

  factory CardInfoWithPlayer.from(List<String> values) {
    return CardInfoWithPlayer(
        values[0], int.parse(values[1]), int.parse(values[2]));
  }

  @override
  String encode() {
    return "$playerId,$cardIndex,$cardId";
  }

  final String playerId;
  final int cardIndex;
  final int cardId;

  @override
  List<Object?> get props => [playerId, cardIndex, cardId];
}
