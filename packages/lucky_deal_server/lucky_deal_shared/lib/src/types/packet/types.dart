import 'package:lucky_deal_shared/src/types/packet/packet.dart';

enum PacketType {
  createRoom(CreateRoom.from),
  roomCreated(RoomInfo.from),
  memberJoined(PlayerId.from),
  membersUpdated(MembersUpdated.from),
  joinRoom(JoinRoom.from),
  joinedRoom(RoomInfo.from),
  error(ErrorPacket.from),
  startGame(EmptyPacket.from),
  gameStarted(EmptyPacket.from),
  revealCard(RevealCard.from),
  cardRevealed(CardRevealed.from),
  memberLeft(PlayerId.from),
  connected(Connected.from),
  ackConnection(EmptyPacket.from),
  pickUp(EmptyPacket.from),
  pickedUp(PickedUp.from),
  previewCard(CardInfo.from),
  cardPreviewed(CardWithPlayer.from),
  unpreviewCard(CardInfo.from),
  cardUnpreviewed(CardWithPlayer.from),
  turnPassed(PlayerId.from),
  playCard(CardInfo.from),
  cardPlayed(CardInfoWithPlayer.from),
  passTurn(EmptyPacket.from),
  discard(CardInfo.from),
  discarded(CardInfoWithPlayer.from);

  const PacketType(this.decode);

  final PacketData Function(List<String> values) decode;
}
