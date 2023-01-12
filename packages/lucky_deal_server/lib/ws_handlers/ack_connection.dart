import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> ackConnectionHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final sid = context.read<ConnectionInfoProvider>().sid;
  channel.sink.add(WsDto(PacketType.connected, Connected(sid)).encode());
}
