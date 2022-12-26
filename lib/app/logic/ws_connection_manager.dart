import 'package:monopoly_deal/app/logic/logic.dart';

class WsConnectionManager {
  WsConnection? _connection;

  WsConnection connection() {
    return _connection ??= WsConnection();
  }

  void close() {
    _connection?.close();
    _connection = null;
  }
}
