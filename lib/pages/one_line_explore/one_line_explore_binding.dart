import 'package:get/get.dart';
import 'one_line_explore_logic.dart';

class OneLineExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OneLineExploreLogic());
  }
}
