import 'package:flutter/material.dart' hide ConnectionState;
import 'package:logging/logging.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/config.dart';
import 'package:web_socket_client/web_socket_client.dart';

class WsGateway extends ChangeNotifier {
  WebSocket? socket;
  ServerPacket? serverPacket;
  ConnectionState? connectionState;
  String? sid;
  final _wsAdapter = WsAdapter();
  final _logger = Logger("$WsGateway");
  final List<Function(String sid)> _pendingRequests = [];

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

    socket!.messages.map((event) => _wsAdapter.decode(event)).listen(
      (event) {
        _logger.info(event);
        if (event is ConnectedPacket) {
          sid = event.sid;
          for (var request in _pendingRequests) {
            _sendPacket(sid!, request);
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

  void send(Function(String sid) request) {
    if (sid == null) {
      _pendingRequests.add(request);
      return;
    }
    _sendPacket(sid!, request);
  }

  void _sendPacket(String sid, Function(String sid) buildPacket) {
    final message = _wsAdapter.encode(buildPacket(sid));
    _logger.info(message);
    socket?.send(message);
  }
}
