import 'package:flame/components.dart';

mixin TapOutsideCallback on Component {
  bool tapOutsideSubscribed = true;
  void onTapOutside() {}
}
