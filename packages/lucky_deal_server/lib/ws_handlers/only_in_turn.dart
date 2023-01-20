import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/models/models.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_server/ws_handlers/ws_handlers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

WsHandler onlyInTurn(
  Future<void> Function(
    WebSocketChannel channel,
    RequestContext context,
    PacketData data,
    String sid,
    RoomMembersManager room,
  )
      next,
) {
  return (
    WebSocketChannel channel,
    RequestContext context,
    PacketData data,
  ) async {
    final sid = context.read<ConnectionInfoProvider>().sid;
    final room = context.read<RoomsManager>().findByMember(sid);
    if (room == null) throw StateError('Room does not exist');
    if (!room.gameMaster.isMyTurn(room.memberIndex(sid))) return;
    await next(channel, context, data, sid, room);
  };
}
