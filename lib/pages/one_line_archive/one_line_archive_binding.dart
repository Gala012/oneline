import 'package:get/get.dart';
import 'one_line_archive_logic.dart';

class OneLineArchiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OneLineArchiveLogic>(() => OneLineArchiveLogic());
  }
}
