import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:redis/redis.dart';

typedef CommandGenerator = Future<Command> Function();

final redisProvider = provider<CommandGenerator>(
  (context) => () {
    final config = context.read<Config>().redisConfig;
    return RedisConnection().connect(config.host, config.port);
  },
);
