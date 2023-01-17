import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/models/models.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> joinRoomHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final sid = context.read<ConnectionInfoProvider>().sid;
  final roomId = (data as JoinRoom).roomId;
  final room = context.read<RoomsManager>().findById(roomId);
  if (room.isFull) {
    throw StateError('Room is full');
  }
  room
    ..members.listen((members) {
      channel.sink.add(
        WsDto(PacketType.membersUpdated, MembersUpdated(members)).encode(),
      );
    })
    ..newJoined.listen((newJoined) {
      channel.sink.add(
        WsDto(PacketType.memberJoined, PlayerId(newJoined)).encode(),
      );
    })
    ..newLeft.listen((newLeft) {
      channel.sink.add(
        WsDto(PacketType.memberLeft, PlayerId(newLeft)).encode(),
      );
    })
    ..messages.listen((msg) {
      channel.sink.add(msg);
    })
    ..join(sid);
  channel.sink.add(
    WsDto(
      PacketType.joinedRoom,
      RoomInfo(roomId, room.gameMaster.playerAmount),
    ).encode(),
  );
}
