import 'package:get/get.dart';
import 'one_line_settings_logic.dart';
class OneLineSettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OneLineSettingsLogic());
  }
}
