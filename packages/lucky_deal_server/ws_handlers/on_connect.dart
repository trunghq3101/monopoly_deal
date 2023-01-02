import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:uuid/uuid.dart';

void onConnectHandler(WebSocketChannel channel) {
  final sid = const Uuid().v4();
  channel.sink.add(
    WsDto(
      PacketType.connected,
      ConnectedPacket(sid),
    ).encode(),
  );
}
