import 'package:lucky_deal_shared/src/types/packet/packet.dart';
import 'package:lucky_deal_shared/src/types/packet/to_pick_up_cards.dart';

enum PacketType {
  createRoom(EmptyPacket.from),
  roomCreated(RoomCreated.from),
  memberJoined(MemberJoined.from),
  membersUpdated(MembersUpdated.from),
  joinRoom(JoinRoom.from),
  joinedRoom(JoinedRoom.from),
  error(ErrorPacket.from),
  startGame(EmptyPacket.from),
  gameStarted(EmptyPacket.from),
  getToPickUpCards(EmptyPacket.from),
  toPickUpCards(ToPickUpCards.from);

  const PacketType(this.decode);

  final PacketData Function(List<String> values) decode;
}
