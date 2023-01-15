import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/models/models.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> playCardHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final sid = context.read<ConnectionInfoProvider>().sid;
  final room = context.read<RoomsManager>().findByMember(sid);
  if (room == null) throw StateError('Room does not exist');
  final cardIndex = (data as CardInfo).cardIndex;
  final playedCardId =
      room.gameMaster.play(cardIndex, room.memberIndex(sid))?.id;
  if (playedCardId != null) {
    room.broadcast(
      sid,
      WsDto(
        PacketType.cardPlayed,
        CardInfoWithPlayer(sid, cardIndex, playedCardId),
      ).encode(),
    );
  }
}
