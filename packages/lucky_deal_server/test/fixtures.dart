import 'package:lucky_deal_server/providers/providers.dart';
import 'package:redis/redis.dart';

const testSid = 'a473ff7b-b3cd-4899-a04d-ea0fbd30a72e';
final testConfig = Config(RedisConfig('localhost', 6379));
Future<Command> testCommandGenerator() =>
    RedisConnection().connect('localhost', 6379);
const testRoomId = 'roomId';
