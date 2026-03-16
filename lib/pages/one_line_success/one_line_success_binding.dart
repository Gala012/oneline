import 'package:get/get.dart';
import 'one_line_success_logic.dart';
class OneLineSuccessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OneLineSuccessLogic());
  }
}
