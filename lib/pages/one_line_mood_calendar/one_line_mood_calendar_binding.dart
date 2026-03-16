import 'package:get/get.dart';
import 'one_line_mood_calendar_logic.dart';

class OneLineMoodCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OneLineMoodCalendarLogic());
  }
}
