import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> createRoomHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final roomId = context.read<RandomProvider>().roomIdGenerator();
  final sid = context.read<ConnectionInfoProvider>().sid;
  channel.sink.add(WsDto(PacketType.roomCreated, RoomCreated(roomId)).encode());
  context.read<RoomsManager>().create(roomId)
    ..members.listen((members) {
      channel.sink.add(
        WsDto(PacketType.membersUpdated, MembersUpdated(members)).encode(),
      );
    })
    ..newJoined.listen((newJoined) {
      channel.sink.add(
        WsDto(PacketType.memberJoined, MemberJoined(newJoined)).encode(),
      );
    })
    ..join(sid);
}
