import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OneLineSettingsLogic extends GetxController {
  final version = '1.0.0'.obs;
  @override
  void onInit() {
    super.onInit();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      version.value = packageInfo.version;
    } catch (e) {
      version.value = '1.0.0';
    }
  }
}
