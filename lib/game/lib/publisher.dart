import 'package:collection/collection.dart';
import 'package:flame/components.dart';

class PublisherComponent<T> extends Component with Publisher<T> {
  @override
  void onRemove() {
    _subscribers.clear();
    super.onRemove();
  }
}

mixin Publisher<T> {
  final List<Subscriber<T>> _subscribers = [];

  UnmodifiableListView<Subscriber<T>> get subscribers =>
      UnmodifiableListView(_subscribers);

  void addSubscriber(Subscriber<T> subscriber) {
    _subscribers.add(subscriber);
  }

  void removeSubscriber(Subscriber<T> subscriber) {
    _subscribers.remove(subscriber);
  }

  void notify(T event, [Object? payload]) {
    _cleanRemovedComponents();
    for (var s in _subscribers) {
      s.onNewEvent(event, payload);
    }
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
  void onNewEvent(T event, [Object? payload]);
}
