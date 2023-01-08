import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';

class RoomModel extends InheritedNotifier<RoomGateway> {
  const RoomModel({
    super.key,
    required super.child,
    super.notifier,
  });

  static RoomGateway of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RoomModel>()!.notifier!;
  }
}
