import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

Future<void> joinRoomHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final sid = context.read<ConnectionInfoProvider>().sid;
  final roomId = (data as JoinRoomPacket).roomId;
  channel.sink.add(
    WsDto(
      PacketType.joinedRoom,
      JoinRoomPacket(roomId),
    ).encode(),
  );

  final cmd = await context.read<CommandGenerator>()();
  final membersValue = await cmd.send_object([
    'XREVRANGE',
    '$roomId-${PacketType.membersUpdated}',
    '+',
    '-',
    'COUNT',
    1
  ]);
  final membersRaw =
      (((membersValue as List)[0] as List)[1] as List)[1] as String;
  final members = (WsDto.from(membersRaw).data as MembersUpdated).members;
  await cmd.send_object([
    'XADD',
    '$roomId-${PacketType.memberJoined}',
    '*',
    'value',
    WsDto(PacketType.memberJoined, MemberJoined(sid)).encode()
  ]);
  final membersUpdatedPacket = WsDto(
    PacketType.membersUpdated,
    MembersUpdated([...members, sid]),
  ).encode();
  await cmd.send_object([
    'XADD',
    '$roomId-${PacketType.membersUpdated}',
    '*',
    'value',
    membersUpdatedPacket,
  ]);
  channel.sink.add(
    membersUpdatedPacket,
  );
}
