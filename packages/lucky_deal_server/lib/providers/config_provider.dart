import 'package:dart_frog/dart_frog.dart';

class Config {
  Config(this.redisConfig);

  final RedisConfig redisConfig;
}

class RedisConfig {
  RedisConfig(this.host, this.port);

  final String host;
  final int port;
}

final configProvider = provider<Config>(
  (_) => Config(RedisConfig('localhost', 6379)),
);
