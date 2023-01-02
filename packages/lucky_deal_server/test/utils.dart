import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:redis/redis.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid_util.dart';

const testSid = 'a473ff7b-b3cd-4899-a04d-ea0fbd30a72e';
final testUuidOptions = UuidOptions({
  'rng': UuidUtil.mathRNG,
  'namedArgs': {const Symbol('seed'): 1}
});
final testConfig = Config(RedisConfig('localhost', 6379));
Future<Command> testCommandGenerator() =>
    RedisConnection().connect('localhost', 6379);

class PacketMatcher extends CustomMatcher {
  PacketMatcher(
    Object? valueOrMatcher,
  ) : super('has', 'a PacketData', valueOrMatcher);

  @override
  Object? featureValueOf(dynamic actual) => WsDto.from(actual as String).data;
}
