import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> previewCardHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final sid = context.read<ConnectionInfoProvider>().sid;
  final room = context.read<RoomsManager>().findByMember(sid);
  if (room == null) throw StateError('Room does not exist');
  final cardIndex = (data as CardInfo).cardIndex;
  final previewResult = room.deck.preview(cardIndex, room.memberIndex(sid));
  if (previewResult.previewedIndex != null) {
    room.broadcast(
      sid,
      WsDto(
        PacketType.cardPreviewed,
        CardWithPlayer(sid, previewResult.previewedIndex!),
      ).encode(),
    );
  }
  if (previewResult.unpreviewedIndex != null) {
    room.broadcast(
      sid,
      WsDto(
        PacketType.cardUnpreviewed,
        CardWithPlayer(sid, previewResult.unpreviewedIndex!),
      ).encode(),
    );
  }
}
