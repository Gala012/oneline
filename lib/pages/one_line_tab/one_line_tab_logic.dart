import 'package:get/get.dart';
import '../one_line_archive/one_line_archive_logic.dart';
class OneLineTabLogic extends GetxController {
  final currentIndex = 0.obs;
  void changeTab(int index) {
    currentIndex.value = index;
    if (index == 2) {
      Get.find<OneLineArchiveLogic>().loadData();
    }
  }
}
