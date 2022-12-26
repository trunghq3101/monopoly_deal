import 'dart:async';

import 'package:logging/logging.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart';

class WsConnection {
  final _sidStreamController = StreamController<String>.broadcast();
  final _logger = Logger("$WsConnection");
  final List<Function(String sid)> _pendingRequests = [];

  final socket = WebSocket(Uri.parse("ws://localhost:3000/game"));
  final wsAdapter = WsAdapter();
  String? sid;

  Stream<ConnectionState> get stateStream =>
      socket.connection.asBroadcastStream();
  Stream<ServerPacket> get messageStream => socket.messages
      .asBroadcastStream()
      .map((event) => wsAdapter.decode(event));
  Stream<String> get sidStream => _sidStreamController.stream;

  //TO-DO: handle connection close and error
  WsConnection() {
    sidStream.listen((event) {
      sid = event;
      _logger.info("Sid: $sid");
      for (var request in _pendingRequests) {
        _sendPacket(sid!, request);
      }
    });
    stateStream.listen((event) {
      _logger.info(event);
    });
    messageStream.listen((event) {
      _logger.info(event);
      if (event is ConnectedPacket) {
        _sidStreamController.add(event.sid);
      }
    });
  }

  void createRoom() {
    _ensureSendPacketWithSid((sid) => CreateRoomPacket(sid: sid));
  }

  void joinRoom(int roomId) {
    _ensureSendPacketWithSid((sid) => JoinRoomPacket(sid: sid, roomId: roomId));
  }

  void close() {
    _sidStreamController.close();
    socket.close();
  }

  void _ensureSendPacketWithSid(Function(String sid) request) {
    if (sid == null) {
      _pendingRequests.add(request);
      return;
    }
    _sendPacket(sid!, request);
  }

  void _sendPacket(String sid, Function(String sid) buildPacket) {
    final message = wsAdapter.encode(buildPacket(sid));
    _logger.info(message);
    socket.send(message);
  }
}
