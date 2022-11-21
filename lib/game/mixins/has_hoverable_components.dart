import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:meta/meta.dart';

mixin HasHoverableComponents on FlameGame implements MouseMovementDetector {
  bool continuePropagation = false;
  int _nextHoverId = 0;
  int? _lastHoverId;
  HoverCallbacks? _lastHoverComponent;

  @override
  void onMouseMove(PointerHoverInfo info) {
    final event = HoverEvent.fromInfo(info);
    event.deliverAtPoint(
        rootComponent: this,
        eventHandler: (HoverCallbacks? component) {
          final isHoveringNothing = component == null;
          final isNeverHovered =
              !isHoveringNothing && component.hoverId == null;
          int? hoverId = isHoveringNothing
              ? null
              : (isNeverHovered ? _nextHoverId++ : component.hoverId!);
          final isHoveringDifferentComponent = hoverId != _lastHoverId;
          if (isHoveringDifferentComponent) {
            if (_lastHoverComponent?.isMounted == true) {
              _lastHoverComponent?.onHoverLeave();
            }
            _lastHoverId = hoverId;
            _lastHoverComponent = component;
            if (!isHoveringNothing) {
              component.onHoverEnter(hoverId!);
            }
          }
          component?.onHover(event);
        });
  }
}

mixin HoverCallbacks on Component {
  int? hoverId;

  @mustCallSuper
  void onHoverEnter(int hoverId) {
    this.hoverId = hoverId;
  }

  void onHoverLeave() {}

  void onHover(HoverEvent event) {}

  @override
  @mustCallSuper
  void onMount() {
    super.onMount();
    assert(
      findGame()! is HasHoverableComponents,
      'HoverableCallbacks Components can only be added to a FlameGame with '
      'HasHoverableComponents',
    );
  }

  @override
  @mustCallSuper
  void onRemove() {
    onHoverLeave();
  }
}

class HoverEvent {
  HoverEvent(this.canvasPosition);

  factory HoverEvent.fromInfo(PointerHoverInfo info) =>
      HoverEvent(info.eventPosition.widget);

  final Vector2 canvasPosition;

  /// Event position in the local coordinate space of the current component.
  ///
  /// This property is only accessible when the event is being propagated to
  /// the components via [deliverAtPoint]. It is an error to try to read this
  /// property at other times.
  Vector2 get localPosition => renderingTrace.last;

  /// The stacktrace of coordinates of the event within the components in their
  /// rendering order.
  final List<Vector2> renderingTrace = [];

  void deliverAtPoint<T extends Component>({
    required Component rootComponent,
    required void Function(T? component) eventHandler,
  }) {
    final childOrNull = rootComponent
        .componentsAtPoint(canvasPosition, renderingTrace)
        .whereType<T>()
        .firstOrNull;
    eventHandler(childOrNull);
    CameraComponent.currentCameras.clear();
  }
}
