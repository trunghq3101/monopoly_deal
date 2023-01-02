import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/providers/providers.dart';

Handler middleware(Handler handler) =>
    handler.use(uuidOptionsProvider).use(redisProvider);
