import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/models/models.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> startGameHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final sid = context.read<ConnectionInfoProvider>().sid;
  final room = context.read<RoomsManager>().findByMember(sid);
  room?.gameMaster.onStart();
  room?.broadcast(
    sid,
    WsDto(
      PacketType.gameStarted,
      EmptyPacket(),
    ).encode(),
  );
  room?.broadcast(
    sid,
    WsDto(
      PacketType.turnPassed,
      PlayerId(sid),
    ).encode(),
  );
}
