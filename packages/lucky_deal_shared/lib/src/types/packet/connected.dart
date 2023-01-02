import 'package:equatable/equatable.dart';

import 'packet.dart';

class ConnectedPacket with EquatableMixin, ServerPacket {
  ConnectedPacket({required this.sid});

  factory ConnectedPacket.from(Object? data) {
    return ConnectedPacket(sid: data as String);
  }

  String encode() {
    return sid;
  }

  final String sid;

  @override
  List<Object?> get props => [sid];
}
