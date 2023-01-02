import 'package:dart_frog/dart_frog.dart';

class UuidOptions {
  UuidOptions(this.options);

  final Map<String, dynamic> options;
}

final uuidOptionsProvider = provider<UuidOptions>((_) => UuidOptions({}));
