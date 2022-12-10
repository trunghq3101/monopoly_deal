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
    _cleanRemovedComponents();
    for (var s in _subscribers) {
      s.onNewEvent(event);
    }
  }

  @override
  void onRemove() {
    _subscribers.clear();
    super.onRemove();
  }

  void _cleanRemovedComponents() {
    final pendingRemoved = [];
    for (var s in _subscribers) {
      if (s is Component && (s as Component).isRemoved) {
        pendingRemoved.add(s);
      }
    }
    for (var s in pendingRemoved) {
      removeSubscriber(s);
    }
  }
}

mixin Subscriber<T> {
  void onNewEvent(T event);
}
