import 'package:get/get.dart';
import 'one_line_compose_logic.dart';

class OneLineComposeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OneLineComposeLogic>(() => OneLineComposeLogic());
  }
}
