// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  Directory.current = '../../';
  final fileNames = [
    'android/app/google-services.json',
    'ios/Runner/GoogleService-Info.plist',
    'ios/firebase_app_id_file.json',
    'lib/firebase_options.dart',
    'macos/Runner/GoogleService-Info.plist',
    'macos/firebase_app_id_file.json',
  ];
  for (var f in fileNames) {
    print(f);
    print(Process.runSync('base64', ['-in', f]).stdout);
  }
}
