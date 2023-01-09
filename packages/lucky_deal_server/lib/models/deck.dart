class Deck {
  final List<int> _cards = List.generate(100, (index) => index);

  int at(int index) => _cards[index];

  void shuffle() {
    _cards.shuffle();
  }

  List<int> toBeDealed(int playerIndex, int totalPlayerAmount) {
    return List.generate(5, (index) => playerIndex + index * totalPlayerAmount);
  }
}
