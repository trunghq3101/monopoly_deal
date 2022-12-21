import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart';

void main() {
  group('WsConnection', () {
    late WsConnection connection;

    setUp(() {
      connection = WsConnection();
    });

    tearDown(() {
      connection.socket.close();
    });

    test('connect', () async {
      expect(
        connection.stateStream,
        emitsInOrder([const Connecting(), const Connected()]),
      );
    });
  });
}
