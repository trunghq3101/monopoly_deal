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
  final _logger = Logger("$WsGateway");
  final List<WsDto> _pendingRequests = [];

  void connect() {
    if (socket != null) return;
    socket = WebSocket(Uri.parse("$wsHost/game"));
    socket!.connection.listen(
      (event) {
        _logger.info(event);
        connectionState = event;
        if (connectionState is Connected) {
          for (var request in _pendingRequests) {
            _sendPacket(request);
          }
        }
        notifyListeners();
      },
      onError: _catchSocketError,
    );

    socket!.messages.map((event) => WsDto.from(event).data).listen(
      (event) {
        _logger.info(event);

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
    serverPacket = null;
    connectionState = null;
    _pendingRequests.clear();
    notifyListeners();
  }

  void send(WsDto dto) {
    if (socket?.connection.state is! Connected) {
      _pendingRequests.add(dto);
      return;
    }
    _sendPacket(dto);
  }

  void _sendPacket(WsDto dto) {
    final message = dto.encode();
    _logger.info(message);
    socket?.send(message);
  }
}
