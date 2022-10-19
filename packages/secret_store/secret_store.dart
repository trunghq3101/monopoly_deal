import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  Directory.current = '../../';
  final passFile = File('passphrase');
  final passPhrase = passFile.existsSync()
      ? passFile.readAsStringSync()
      : Platform.environment['GPG_PASSPHRASE']!;
  final fileNames = [
    'android/app/google-services.json',
    'ios/Runner/GoogleService-Info.plist',
    'ios/firebase_app_id_file.json',
    'lib/firebase_options.dart',
    'macos/Runner/GoogleService-Info.plist',
    'macos/firebase_app_id_file.json',
    'android/upload-keystore.jks',
    'android/key.properties',
  ];

  switch (args[0]) {
    case "en":
      final data = {
        for (var item in fileNames) item: File(item).readAsBytesSync()
      };
      final encoded = base64Encode(utf8.encode(jsonEncode(data)));
      File('encoded').writeAsStringSync(encoded);
      Process.runSync('gpg', ['--import', 'key.pub']);
      Process.runSync('gpg', [
        '--passphrase',
        passPhrase,
        '--encrypt',
        '--sign',
        '--armor',
        '-r',
        'trunghq3101@gmail.com',
        '--output',
        'encoded.asc',
        'encoded'
      ]);
      File('encoded').deleteSync();
      break;
    case "de":
      Process.runSync('gpg', ['--import', 'key']);
      Process.runSync('gpg', ['encoded.asc']);
      final encoded = File('encoded').readAsStringSync();
      final data = Map<String, List<dynamic>>.from(
          jsonDecode(utf8.decode(base64Decode(encoded))));
      for (var path in fileNames) {
        File(path).writeAsBytesSync(data[path]!.map((e) => e as int).toList());
      }
      File('encoded').deleteSync();
      break;
  }
}
