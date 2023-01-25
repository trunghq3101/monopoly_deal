import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/models/models.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> passTurnHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
  String sid,
  RoomMembersManager room,
) async {
  if (!room.gameMaster.nextTurn(room.memberIndex(sid))) return;
  room.broadcast(
    sid,
    WsDto(
      PacketType.turnPassed,
      PlayerId(room.memberId(room.gameMaster.turnPlayerIndex)),
    ).encode(),
  );
}
