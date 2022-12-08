import 'package:flame/components.dart';
import 'package:monopoly_deal/game/components/card/card_publisher.dart';
import 'package:monopoly_deal/game/components/card/card_state_machine.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class CardProvider extends Component {
  @override
  Future<void>? onLoad() async {
    children.register<CardPublisher>();
    children.register<CardStateMachine>();
    add(CardPublisher());
    add(CardStateMachine());
  }

  T get<T extends Publisher>() {
    if (children.query<T>().isEmpty) throw PublisherNotFoundException();
    return children.query<T>().first;
  }
}
