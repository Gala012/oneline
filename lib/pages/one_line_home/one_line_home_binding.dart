import 'package:get/get.dart';
import 'one_line_home_logic.dart';

class OneLineHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OneLineHomeLogic>(() => OneLineHomeLogic());
  }
}
