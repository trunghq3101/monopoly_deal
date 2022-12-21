import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart';

class WsConnection {
  final socket = WebSocket(Uri.parse("ws://localhost:3000/game"));
  final wsAdapter = WsAdapter();

  Stream<ConnectionState> get stateStream => socket.connection;
  Stream<ServerPacket> get messageStream =>
      socket.messages.map((event) => wsAdapter.decode(event));
}
