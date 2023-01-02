import 'package:equatable/equatable.dart';

import 'packet.dart';

class CreateRoomPacket extends ClientPacket with EquatableMixin {
  CreateRoomPacket({required super.sid});
}
