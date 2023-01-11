import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:logging/logging.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_server/ws_handlers/registry.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

final logger = Logger('game');

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) {
      final sid = context.read<RandomProvider>().uuidGenerator();
      final contextWithConnectionInfo = context.provide<ConnectionInfoProvider>(
        () => ConnectionInfoProvider(sid: sid),
      );
      channel.stream.map((event) {
        logger.info(event);
        return WsDto.from(event as String);
      }).listen(
        (packet) async {
          if (!packetHandlers.containsKey(packet.event)) {
            throw UnsupportedError(
              'Unsupported packet type: ${packet.event}',
            );
          }
          try {
            await packetHandlers[packet.event]!(
              channel,
              contextWithConnectionInfo,
              packet.data,
            );
          } catch (e, s) {
            logger.warning('Error', e, s);
            channel.sink.add(
              WsDto(
                PacketType.error,
                ErrorPacket(PacketErrorType.general),
              ).encode(),
            );
          }
        },
        onDone: () {
          context.read<RoomsManager>().findByMember(sid)?.leave(sid);
          logger.info('disconnected');
        },
        onError: (Object e, StackTrace s) {
          logger.warning('Error', e, s);
          channel.sink.addError(e, s);
        },
      );
    },
  );

  return handler(context);
}
