import 'package:collection/collection.dart';
import 'package:lucky_deal_server/models/models.dart';

class Deck {
  Deck({int? playersAmount}) : _playersAmount = playersAmount ?? 2;

  final int _playersAmount;
  final List<Card> _cards = List.generate(100, (index) => Card(id: index));
  late final _inHandCardIndexes =
      List.generate(_playersAmount, (index) => <int>[]);
  late final _playedCardIndexes =
      List.generate(_playersAmount, (index) => <int>[]);
  int _nextDealedIndex = 0;

  int at(int index) => _cards[index].id;

  Card cardAt(int index) => _cards[index];

  void shuffle() {
    _cards.shuffle();
  }

  List<int> pickUp(int playerIndex) {
    return _inHandCardIndexes[playerIndex];
  }

  int reveal(int playerIndex, {required int at}) {
    if (!_inHandCardIndexes[playerIndex].contains(at)) {
      throw StateError('Player at $playerIndex not allow to read card at $at');
    }
    return this.at(at);
  }

  void _dealNextCardTo(int playerIndex) {
    _inHandCardIndexes[playerIndex].add(_nextDealedIndex);
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

  PreviewResult preview(int cardIndex, int playerIndex) {
    if (!_isCardInHand(cardIndex, playerIndex)) {
      return PreviewResult.invalid();
    }
    final previewing = _previewingOf(playerIndex);
    cardAt(cardIndex).previewing = true;
    if (previewing == null) return PreviewResult(cardIndex, null);
    cardAt(previewing).previewing = false;
    return PreviewResult(cardIndex, previewing);
  }

  int? unpreview(int cardIndex, int playerIndex) {
    if (!_isCardInHand(cardIndex, playerIndex)) {
      return null;
    }
    final previewing = _previewingOf(playerIndex);
    if (previewing == null) return null;
    cardAt(previewing).previewing = false;
    return cardIndex;
  }

  int? play(int cardIndex, int playerIndex) {
    if (!_isCardInHand(cardIndex, playerIndex) ||
        !cardAt(cardIndex).previewing) {
      return null;
    }
    cardAt(cardIndex).previewing = false;
    _inHandCardIndexes[playerIndex].remove(cardIndex);
    _playedCardIndexes[playerIndex].add(cardIndex);
    return cardIndex;
  }

  bool _isCardInHand(int cardIndex, int playerIndex) {
    return _inHandCardIndexes[playerIndex].contains(cardIndex);
  }

  int? _previewingOf(int playerIndex) => _inHandCardIndexes[playerIndex]
      .firstWhereOrNull((index) => cardAt(index).previewing);
}

class PreviewResult {
  PreviewResult(this.previewedIndex, this.unpreviewedIndex);

  factory PreviewResult.invalid() => PreviewResult(null, null);

  final int? previewedIndex;
  final int? unpreviewedIndex;
}
