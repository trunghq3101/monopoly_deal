import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> cardEventHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
  PacketType type,
) async {
  final sid = context.read<ConnectionInfoProvider>().sid;
  final room = context.read<RoomsManager>().findByMember(sid);
  if (room == null) throw StateError('Room does not exist');
  final cardIndex = (data as CardInfo).cardIndex;
  if (!room.deck.verifyCardOwner(cardIndex, room.memberIndex(sid))) {
    throw StateError('Card at $cardIndex not belong to player $sid');
  }
  room.broadcast(sid, WsDto(type, CardWithPlayer(sid, cardIndex)).encode());
}
