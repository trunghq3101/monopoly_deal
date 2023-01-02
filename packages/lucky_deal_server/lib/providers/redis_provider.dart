import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:redis/redis.dart';

typedef CommandGenerator = Future<Command> Function();

final redisProvider = provider<CommandGenerator>(
  (context) => () {
    // TODO: figure out a way to inject config
    // final config = context.read<Config>().redisConfig;
    final config = RedisConfig('localhost', 6379);
    return RedisConnection().connect(config.host, config.port);
  },
);
