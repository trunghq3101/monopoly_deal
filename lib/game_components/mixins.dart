import 'package:flame/components.dart';

mixin TapOutsideCallback on Component {
  bool tapOutsideEnabled = true;
  void onTapOutside() {}
}
