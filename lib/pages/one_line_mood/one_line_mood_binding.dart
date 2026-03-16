import 'package:get/get.dart';
import 'one_line_mood_logic.dart';

class OneLineMoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OneLineMoodLogic>(() => OneLineMoodLogic());
  }
}
