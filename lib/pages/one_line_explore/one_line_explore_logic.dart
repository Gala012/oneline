import 'package:get/get.dart';
import '../../services/quote_service.dart';

class OneLineExploreLogic extends GetxController {
  final QuoteService _quoteService = Get.find<QuoteService>();
  List<String> get themes => _quoteService.themes;
  void onThemeSelected(String theme) {
    Get.toNamed('/theme', arguments: {'theme': theme});
  }
}
