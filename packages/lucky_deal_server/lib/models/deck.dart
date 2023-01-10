class Deck {
  Deck({int? playersAmount}) : _playersAmount = playersAmount ?? 2;

  final int _playersAmount;
  final List<int> _cards = List.generate(100, (index) => index);
  late final _revealedCards = List.generate(_playersAmount, (index) => []);
  int _nextRevealIndex = 0;

  int at(int index) => _cards[index];

  void shuffle() {
    _cards.shuffle();
  }

  int pickUp(int playerIndex, {required int at}) {
    if (!_revealedCards[playerIndex].contains(at)) {
      throw StateError('Player at $playerIndex not allow to read card at $at');
    }
    return this.at(at);
  }

  void _revealNextCardTo(int playerIndex) {
    _revealedCards[playerIndex].add(_nextRevealIndex);
    _nextRevealIndex++;
  }

  void onStart() {
    var playerIndex = 0;
    for (var i = 0; i < _playersAmount * 5; i++) {
      _revealNextCardTo(playerIndex);
      playerIndex = (playerIndex + 1) % _playersAmount;
    }
  }

  void onDraw(int playerIndex) {
    _revealNextCardTo(playerIndex);
    _revealNextCardTo(playerIndex);
  }
}
