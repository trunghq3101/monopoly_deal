import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:monopoly_deal/app/main_app.dart';

void main() {
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      log('${record.level.name}: ${record.time}: ${record.error}\n${record.stackTrace}');
    }
  });
  runApp(const MainApp());
}
