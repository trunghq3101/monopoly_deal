import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:logging/logging.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:redis/redis.dart';

Future<void> createRoomHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final roomId = context.read<RandomProvider>().roomIdGenerator();
  final sid = context.read<ConnectionInfoProvider>().sid;
  final members = [sid];
  channel.sink.add(WsDto(PacketType.roomCreated, RoomCreated(roomId)).encode());
  final membersUpdatedPacket =
      WsDto(PacketType.membersUpdated, MembersUpdated(members)).encode();
  final cmd = await context.read<CommandGenerator>()();
  await cmd.send_object([
    'XADD',
    '$roomId-${PacketType.membersUpdated}',
    '*',
    'value',
    membersUpdatedPacket,
  ]);
  channel.sink.add(membersUpdatedPacket);
  xread(channel, cmd, roomId, PacketType.memberJoined);
  xread(channel, cmd, roomId, PacketType.membersUpdated);
}

void xread(
  WebSocketChannel channel,
  Command cmd,
  String roomId,
  PacketType packetType,
) {
  cmd.send_object(
    ['XREAD', 'BLOCK', 0, 'STREAMS', '$roomId-$packetType', r'$'],
  ).then(
    (value) {
      final data = (((((value as List)[0] as List)[1] as List)[0] as List)[1]
          as List)[1] as String;
      channel.sink.add(data);
      xread(channel, cmd, roomId, packetType);
    },
    onError: (Object e, StackTrace r) =>
        Logger('xread').warning('XREAD error', e, r),
  );
}
