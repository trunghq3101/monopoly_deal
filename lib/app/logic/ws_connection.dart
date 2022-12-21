import 'package:web_socket_client/web_socket_client.dart';

class WsConnection {
  final socket = WebSocket(Uri.parse("ws://localhost:3000/game"));

  Stream<ConnectionState> get stateStream => socket.connection;
}
