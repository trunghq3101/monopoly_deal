import 'package:dcli/dcli.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart' hide Connected;
import 'package:web_socket_client/web_socket_client.dart';

enum MyCommand { connect, joinRoom, pickUp, singleUser, quit }

Future<void> main(List<String> args) async {
  Future<List<WebSocket>> connect() {
    return Future.wait(
      List.generate(4, (index) async {
        final ws = WebSocket(Uri.parse('ws://localhost:8080/game'));
        while (ws.connection.state is! Connected) {
          await Future.delayed(const Duration(milliseconds: 100), () {});
        }
        print('Connected $index');
        ws.send(WsDto(PacketType.ackConnection, EmptyPacket()).encode());
        return ws;
      }),
    );
  }

  var users = await connect();
  MyCommand cmd;
  while ((cmd = menu(
        prompt: 'Select:',
        options: MyCommand.values,
      )) !=
      MyCommand.quit) {
    switch (cmd) {
      case MyCommand.connect:
        users = await connect();
        break;
      case MyCommand.joinRoom:
        final roomId = ask('Room id:');
        for (final ws in users) {
          ws.send(WsDto(PacketType.joinRoom, JoinRoom(roomId)).encode());
        }
        break;

      case MyCommand.pickUp:
        for (final ws in users) {
          ws.send(WsDto(PacketType.pickUp, EmptyPacket()).encode());
        }
        break;
      case MyCommand.singleUser:
        final receiver = int.parse(ask('Command for user:'));
        final ws = users[receiver];
        final PacketType action = menu(
          prompt: 'Select action:',
          options: [
            PacketType.error,
            PacketType.joinRoom,
            PacketType.pickUp,
          ],
        );
        switch (action) {
          case PacketType.joinRoom:
            final roomId = ask('Room id:');
            ws.send(WsDto(PacketType.joinRoom, JoinRoom(roomId)).encode());
            break;
          default:
            ws.send(WsDto(action, EmptyPacket()).encode());
            break;
        }
        break;
      default:
    }
  }
}
