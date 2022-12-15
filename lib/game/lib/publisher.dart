import 'package:collection/collection.dart';
import 'package:flame/components.dart';

class PublisherComponent extends Component with Publisher {
  @override
  void onRemove() {
    _subscribers.clear();
    super.onRemove();
  }
}

mixin Publisher {
  final List<Subscriber> _subscribers = [];

  UnmodifiableListView<Subscriber> get subscribers =>
      UnmodifiableListView(_subscribers);

  void addSubscriber(Subscriber subscriber) {
    _subscribers.add(subscriber);
  }

  void removeSubscriber(Subscriber subscriber) {
    _subscribers.remove(subscriber);
  }

  void notify(Object event, [Object? payload]) {
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

mixin Subscriber {
  void onNewEvent(Object event, [Object? payload]);
}
