import 'package:flame/components.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class CardDeckPublisher extends Component with Publisher<CardDeckEvent> {}

enum CardDeckEvent { showUp }
