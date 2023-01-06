import 'package:lucky_deal_shared/src/types/packet/packet.dart';

enum PacketType {
  createRoom(EmptyPacket.from),
  roomCreated(RoomCreated.from),
  memberJoined(MemberJoined.from),
  membersUpdated(MembersUpdated.from),
  joinRoom(JoinRoomPacket.from),
  joinedRoom(JoinedRoom.from),
  error(ErrorPacket.from);

  const PacketType(this.decode);

  final PacketData Function(List<String> values) decode;
}
