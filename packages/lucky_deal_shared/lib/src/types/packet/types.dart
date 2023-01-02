import 'package:lucky_deal_shared/src/types/packet/packet.dart';

enum PacketType {
  error(ErrorPacket.from),
  connected(ConnectedPacket.from),
  createRoom(CreateRoomPacket.from),
  joinRoom(JoinRoomPacket.from),
  roomInfo(RoomInfoPacket.from);

  const PacketType(this.decode);

  final PacketData Function(String raw) decode;
}
