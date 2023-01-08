import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../routes/_middleware.dart';
import '../routes/game.dart';

void main() {
  group(
    'Room',
    () {
      late HttpServer server;
      var testRoomId = '';
      var testUserId = '';
      late WebSocket user1;
      late WebSocket user2;
      late WebSocket user3;
      String roomIdGenerator() => testRoomId;
      String uuidGenerator() => testUserId;

      setUp(() async {
        server = await serve(
          const Pipeline().addMiddleware(middleware).addHandler(
            (context) {
              return onRequest(
                context.provide<RandomProvider>(() {
                  return RandomProvider(
                    roomIdGenerator: roomIdGenerator,
                    uuidGenerator: uuidGenerator,
                  );
                }),
              );
            },
          ),
          InternetAddress.anyIPv4,
          0,
        );
      });

      tearDown(() async {
        await server.close();
      });

      Future<void> user1Connect() async {
        testUserId = 'user1id';
        user1 = WebSocket(Uri.parse('ws://localhost:${server.port}'));
        await expectLater(
          user1.connection,
          emitsInOrder([const Connecting(), const Connected()]),
        );
      }

      Future<void> user2Connect() async {
        testUserId = 'user2id';
        user2 = WebSocket(Uri.parse('ws://localhost:${server.port}'));
        await expectLater(
          user2.connection,
          emitsInOrder([const Connecting(), const Connected()]),
        );
      }

      Future<void> user3Connect() async {
        testUserId = 'user3id';
        user3 = WebSocket(Uri.parse('ws://localhost:${server.port}'));
        await expectLater(
          user3.connection,
          emitsInOrder([const Connecting(), const Connected()]),
        );
      }

      Future<void> user1CreateRoom() async {
        testRoomId = 'room${const Uuid().v4()}';
        user1.send('0,');
      }

      test('User 1 can create a room and receive the room code', () async {
        await user1Connect();

        await user1CreateRoom();

        await expectLater(user1.messages, emits('1,$testRoomId'));
      });

      test('User 1 receives error when creating room twice', () async {
        server = await serve(
          const Pipeline().addMiddleware(middleware).addHandler(onRequest),
          InternetAddress.anyIPv4,
          0,
        );
        await user1Connect();
        await user1CreateRoom();
        await user1CreateRoom();

        await expectLater(user1.messages, emitsThrough('6,alreadyInRoom'));
      });

      test(
        'User 1 sees themselves in the room',
        () async {
          await user1Connect();
          await user1CreateRoom();

          await expectLater(user1.messages, emitsThrough('3,user1id'));
        },
      );

      test(
        'User 2 can join the room using the correct room code',
        () async {
          await user1Connect();
          await user2Connect();
          await user1CreateRoom();

          user2.send('4,$testRoomId');

          await expectLater(
            user2.messages,
            emits('5,$testRoomId'),
          );
        },
      );

      test(
        'User 2 sees themselves in the room with user 1',
        () async {
          await user1Connect();
          await user2Connect();
          await user1CreateRoom();

          user2.send('4,$testRoomId');

          await expectLater(
            user2.messages,
            emitsThrough('3,user1id,user2id'),
          );
        },
      );

      test(
        'User 1 receives a notification when user 2 joins the room',
        () async {
          await user1Connect();
          await user2Connect();
          await user1CreateRoom();

          user2.send('4,$testRoomId');

          await expectLater(
            user1.messages,
            emitsThrough('2,user2id'),
          );
        },
      );

      test(
        'User 1 sees themselves in the room with user 2',
        () async {
          await user1Connect();
          await user2Connect();
          await user1CreateRoom();

          user2.send('4,$testRoomId');

          await expectLater(
            user1.messages,
            emitsThrough('3,user1id,user2id'),
          );
        },
      );

      test(
        'User 2 receives a notification when user 3 joins the room',
        () async {
          await user1Connect();
          await user2Connect();
          await user3Connect();
          await user1CreateRoom();

          user2.send('4,$testRoomId');
          user3.send('4,$testRoomId');

          await expectLater(
            user2.messages,
            emitsThrough('2,user3id'),
          );
        },
      );

      test(
        'User 2 sees themselves in the room with user 1 and user 3',
        () async {
          await user1Connect();
          await user2Connect();
          await user3Connect();
          await user1CreateRoom();

          user2.send('4,$testRoomId');
          user3.send('4,$testRoomId');

          await expectLater(
            user2.messages,
            emitsThrough('3,user1id,user2id,user3id'),
          );
        },
      );
    },
    timeout: Timeout.parse('2s'),
  );
}
