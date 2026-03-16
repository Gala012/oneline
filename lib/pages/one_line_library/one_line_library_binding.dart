import 'package:get/get.dart';

import 'one_line_library_logic.dart';

class OneLineLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      OneLineLibraryLogic(),
      permanent: true,
    );
  }
}
