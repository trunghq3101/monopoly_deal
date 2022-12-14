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
  final roomId = (data as JoinRoom).roomId;
  channel.sink.add(
    WsDto(
      PacketType.joinedRoom,
      JoinRoom(roomId),
    ).encode(),
  );
  context.read<RoomsManager>().findById(roomId)
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
    ..newLeft.listen((newLeft) {
      channel.sink.add(
        WsDto(PacketType.memberLeft, MemberLeft(newLeft)).encode(),
      );
    })
    ..messages.listen((msg) {
      channel.sink.add(msg);
    })
    ..join(sid);
}
