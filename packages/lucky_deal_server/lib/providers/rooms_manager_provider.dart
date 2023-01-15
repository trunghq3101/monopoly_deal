import 'package:dart_frog/dart_frog.dart';
import 'package:lucky_deal_server/models/models.dart';

final roomsManager = RoomsManager();
final roomsManagerProvider = provider<RoomsManager>((_) => roomsManager);
