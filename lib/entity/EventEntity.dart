
import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class EventEntity{
  static const COLLECT_CHANGE = 0x11124;
  static const CHANGE_THEME = 0x1255;
  final int code;
  final Object obj;

  EventEntity({this.code, this.obj});
}