import 'package:flame/components.dart';

mixin Publisher<T> on Component {
  final List<Subscriber<T>> _subscribers = [];

  void addSubscriber(Subscriber<T> subscriber) {
    _subscribers.add(subscriber);
  }

  void removeSubscriber(Subscriber<T> subscriber) {
    _subscribers.remove(subscriber);
  }

  void notify(T event) {
    for (var s in _subscribers) {
      s.onNewEvent(event);
    }
  }

  @override
  void onRemove() {
    for (var s in _subscribers) {
      removeSubscriber(s);
      _subscribers.clear();
    }
    super.onRemove();
  }
}

mixin Subscriber<T> on Component {
  void onNewEvent(T event);
}
