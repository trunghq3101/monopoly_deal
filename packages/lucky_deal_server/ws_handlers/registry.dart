import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

import 'create_room.dart';

final packetHandlers =
    <PacketType, void Function(WebSocketChannel channel, PacketData data)>{
  PacketType.createRoom: createRoomHandler,
};
