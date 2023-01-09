import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:test/test.dart';

class PacketMatcher extends CustomMatcher {
  PacketMatcher(
    Object? valueOrMatcher,
  ) : super('has', 'a PacketData', valueOrMatcher);

  @override
  Object? featureValueOf(dynamic actual) => WsDto.from(actual as String).data;
}

Future<void> testDelay() => Future.delayed(const Duration(milliseconds: 200));
Future<void> testDelayZero() => Future.delayed(Duration.zero);
