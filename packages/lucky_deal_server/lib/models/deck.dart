class Deck {
  Deck({int? playersAmount}) : _playersAmount = playersAmount ?? 2;

  final int _playersAmount;
  final List<int> _cards = List.generate(100, (index) => index);
  late final _dealedCards = List.generate(_playersAmount, (index) => <int>[]);
  int _nextDealedIndex = 0;

  int at(int index) => _cards[index];

  void shuffle() {
    _cards.shuffle();
  }

  List<int> pickUp(int playerIndex) {
    return _dealedCards[playerIndex];
  }

  int reveal(int playerIndex, {required int at}) {
    if (!_dealedCards[playerIndex].contains(at)) {
      throw StateError('Player at $playerIndex not allow to read card at $at');
    }
    return this.at(at);
  }

  void _dealNextCardTo(int playerIndex) {
    _dealedCards[playerIndex].add(_nextDealedIndex);
    _nextDealedIndex++;
  }

  void onStart() {
    var playerIndex = 0;
    for (var i = 0; i < _playersAmount * 5; i++) {
      _dealNextCardTo(playerIndex);
      playerIndex = (playerIndex + 1) % _playersAmount;
    }
  }

  void onDraw(int playerIndex) {
    _dealNextCardTo(playerIndex);
    _dealNextCardTo(playerIndex);
  }

  bool verifyCardOwner(int cardIndex, int playerIndex) {
    return _dealedCards[playerIndex].contains(cardIndex);
  }
}
