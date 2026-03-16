import 'package:get/get.dart';
import 'one_line_tab_logic.dart';
import '../one_line_home/one_line_home_logic.dart';
import '../one_line_mood/one_line_mood_logic.dart';
import '../one_line_archive/one_line_archive_logic.dart';
import '../one_line_settings/one_line_settings_logic.dart';
class OneLineTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OneLineTabLogic>(() => OneLineTabLogic());
    Get.lazyPut<OneLineHomeLogic>(() => OneLineHomeLogic());
    Get.lazyPut<OneLineMoodLogic>(() => OneLineMoodLogic());
    Get.lazyPut<OneLineArchiveLogic>(() => OneLineArchiveLogic());
    Get.lazyPut<OneLineSettingsLogic>(() => OneLineSettingsLogic());
  }
}
