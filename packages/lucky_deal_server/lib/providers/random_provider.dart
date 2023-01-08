import 'package:dart_frog/dart_frog.dart';
import 'package:hashids2/hashids2.dart';
import 'package:uuid/uuid.dart';

class RandomProvider {
  RandomProvider({
    String Function()? uuidGenerator,
    String Function()? roomIdGenerator,
  }) {
    this.uuidGenerator = uuidGenerator ?? const Uuid().v4;
    this.roomIdGenerator = roomIdGenerator ??
        () {
          final time = DateTime.now();
          final roomId =
              HashIds(alphabet: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890')
                  .encodeList(
            [time.minute, time.second, time.microsecond],
          );
          return roomId;
        };
  }

  late final String Function() uuidGenerator;
  late final String Function() roomIdGenerator;
}

final randomProvider = provider<RandomProvider>((_) => RandomProvider());
