import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) {
      channel.sink.add(
        WsDto(
          PacketType.connected,
          ConnectedPacket('sid'),
        ).encode(),
      );
      channel.stream.listen(
        print,
        onDone: () => print('disconnected'),
      );
    },
  );

  return handler(context);
}
