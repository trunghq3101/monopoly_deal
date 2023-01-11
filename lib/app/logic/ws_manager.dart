import 'dart:async';

import 'package:monopoly_deal/config.dart';
import 'package:web_socket_client/web_socket_client.dart';

class WsManager {
  WebSocket? _socket;
  Completer<WebSocket> _socketCompleter = Completer<WebSocket>();

  Future<WebSocket> connection() async {
    if (_socket != null) return _socket!;
    _connect();
    return _socketCompleter.future;
  }

  void _connect() {
    final socket = _socket ??= WebSocket(Uri.parse("$wsHost/game"));
    socket.connection.listen(
      (event) {
        if (event is Connected) {
          _socketCompleter.complete(socket);
        }
      },
      onError: _socketCompleter.completeError,
    );
  }

  void disconnect() {
    _socket?.close();
    _socket = null;
    _socketCompleter = Completer<WebSocket>();
  }
}
