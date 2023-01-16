import 'package:flame/components.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';

class GameMaster extends Component {
  GameMaster(this.roomGateway);

  final RoomGateway roomGateway;
  int remainingInTurn = 3;

  void play(int cardIndex) {
    roomGateway.sendCardEvent(PacketType.playCard, cardIndex);
    remainingInTurn--;
  }

  bool get isPlayable => remainingInTurn > 0;

  void takeTurn() {
    remainingInTurn = 3;
  }

  void passTurn() {
    remainingInTurn = 3;
  }
}
