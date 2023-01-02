import 'package:flutter/material.dart' hide ConnectionState;
import 'package:logging/logging.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/config.dart';
import 'package:web_socket_client/web_socket_client.dart';

class WsGateway extends ChangeNotifier {
  WebSocket? socket;
  PacketData? serverPacket;
  ConnectionState? connectionState;
  String? sid;
  final _logger = Logger("$WsGateway");
  final List<PendingRequest> _pendingRequests = [];

  void connect() {
    if (socket != null) return;
    socket = WebSocket(Uri.parse("$wsHost/game"));
    socket!.connection.listen(
      (event) {
        _logger.info(event);
        connectionState = event;
        notifyListeners();
      },
      onError: _catchSocketError,
    );

    socket!.messages.map((event) => WsDto.from(event).data).listen(
      (event) {
        _logger.info(event);
        if (event is ConnectedPacket) {
          sid = event.sid;
          for (var request in _pendingRequests) {
            _sendPacket(sid!, request.type, request.builder);
          }
        }
        if (event is ErrorPacket) {
          switch (event.type) {
            case PacketErrorType.roomNotExist:
              appErrorGateway.addError(AppError(AppErrorType.roomNotExist));
              break;
            case PacketErrorType.alreadyInRoom:
              appErrorGateway.addError(AppError(AppErrorType.alreadyInRoom));
              break;
            default:
          }
        }
        serverPacket = event;
        notifyListeners();
      },
      onError: _catchSocketError,
    );
  }

  void _catchSocketError(e, s) =>
      appErrorGateway.addError(AppError(AppErrorType.socketConnection, e, s));

  void close() {
    socket?.close();
    socket = null;
    sid = null;
    serverPacket = null;
    connectionState = null;
    _pendingRequests.clear();
    notifyListeners();
  }

  void send(PacketType type, SidPacketBuilder builder) {
    if (sid == null) {
      _pendingRequests.add(PendingRequest(type, builder));
      return;
    }
    _sendPacket(sid!, type, builder);
  }

  void _sendPacket(
    String sid,
    PacketType type,
    SidPacketBuilder builder,
  ) {
    final message = WsDto(type, builder(sid)).encode();
    _logger.info(message);
    socket?.send(message);
  }
}

class PendingRequest {
  final PacketType type;
  final SidPacketBuilder builder;

  PendingRequest(this.type, this.builder);
}

typedef SidPacketBuilder = PacketData Function(String sid);
