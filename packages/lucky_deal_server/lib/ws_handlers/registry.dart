import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/ws_handlers/ack_connection.dart';
import 'package:lucky_deal_server/ws_handlers/card_event.dart';
import 'package:lucky_deal_server/ws_handlers/create_room.dart';
import 'package:lucky_deal_server/ws_handlers/join_room.dart';
import 'package:lucky_deal_server/ws_handlers/pick_up.dart';
import 'package:lucky_deal_server/ws_handlers/reveal_card.dart';
import 'package:lucky_deal_server/ws_handlers/start_game.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

final packetHandlers = <
    PacketType,
    FutureOr<void> Function(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
)>{
  PacketType.createRoom: createRoomHandler,
  PacketType.joinRoom: joinRoomHandler,
  PacketType.startGame: startGameHandler,
  PacketType.revealCard: revealCardHandler,
  PacketType.ackConnection: ackConnectionHandler,
  PacketType.pickUp: pickUpHandler,
  PacketType.previewCard: (channel, context, data) =>
      cardEventHandler(channel, context, data, PacketType.cardPreviewed),
  PacketType.unpreviewCard: (channel, context, data) =>
      cardEventHandler(channel, context, data, PacketType.cardUnpreviewed)
};
