import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:uuid/uuid.dart';

void onConnectHandler(WebSocketChannel channel, RequestContext context) {
  final options = context.read<UuidOptions>();
  final sid = const Uuid().v4(options: options.options);
  channel.sink.add(
    WsDto(
      PacketType.connected,
      ConnectedPacket(sid),
    ).encode(),
  );
}
