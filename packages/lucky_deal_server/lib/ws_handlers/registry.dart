import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/ws_handlers/ack_connection.dart';
import 'package:lucky_deal_server/ws_handlers/create_room.dart';
import 'package:lucky_deal_server/ws_handlers/join_room.dart';
import 'package:lucky_deal_server/ws_handlers/only_in_turn.dart';
import 'package:lucky_deal_server/ws_handlers/pass_turn.dart';
import 'package:lucky_deal_server/ws_handlers/pick_up.dart';
import 'package:lucky_deal_server/ws_handlers/play_card.dart';
import 'package:lucky_deal_server/ws_handlers/preview_card.dart';
import 'package:lucky_deal_server/ws_handlers/reveal_card.dart';
import 'package:lucky_deal_server/ws_handlers/start_game.dart';
import 'package:lucky_deal_server/ws_handlers/unpreview_card.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

typedef WsHandler = FutureOr<void> Function(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
);
final packetHandlers = <PacketType, WsHandler>{
  PacketType.createRoom: createRoomHandler,
  PacketType.joinRoom: joinRoomHandler,
  PacketType.startGame: startGameHandler,
  PacketType.revealCard: revealCardHandler,
  PacketType.ackConnection: ackConnectionHandler,
  PacketType.pickUp: pickUpHandler,
  PacketType.previewCard: previewCardHandler,
  PacketType.unpreviewCard: unpreviewCardHandler,
  PacketType.playCard: onlyInTurn(playCardHandler),
  PacketType.passTurn: onlyInTurn(passTurnHandler)
};
