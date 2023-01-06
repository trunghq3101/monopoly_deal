import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> joinRoomHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final sid = context.read<ConnectionInfoProvider>().sid;
  final roomId = (data as JoinRoomPacket).roomId;
  channel.sink.add(
    WsDto(
      PacketType.joinedRoom,
      JoinRoomPacket(roomId),
    ).encode(),
  );
  context.read<RoomsManager>().findById(roomId)
    ..members.listen((members) {
      channel.sink.add(
        WsDto(PacketType.membersUpdated, MembersUpdated(members)).encode(),
      );
    })
    ..join(sid);
}
