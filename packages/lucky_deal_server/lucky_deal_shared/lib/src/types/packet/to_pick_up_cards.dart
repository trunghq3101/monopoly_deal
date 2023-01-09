import 'package:equatable/equatable.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

class ToPickUpCards with EquatableMixin, PacketData {
  ToPickUpCards(this.cardIds);

  factory ToPickUpCards.from(List<String> values) =>
      ToPickUpCards(values.map((e) => int.parse(e)).toList());

  final List<int> cardIds;

  @override
  String encode() => cardIds.join(",");

  @override
  List<Object?> get props => [cardIds];
}
