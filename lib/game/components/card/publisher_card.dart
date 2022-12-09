import 'package:flame/components.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class CardPublisher extends Component with Publisher<CardEvent> {}

enum CardEvent { tapped }
