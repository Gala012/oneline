import 'package:get/get.dart';
import 'one_line_theme_logic.dart';

class OneLineThemeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OneLineThemeLogic());
  }
}
