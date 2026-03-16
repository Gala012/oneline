import 'package:get/get.dart';
import '../../services/quote_service.dart';

class OneLineThemeLogic extends GetxController {
  final QuoteService _quoteService = Get.find<QuoteService>();
  final currentTheme = ''.obs;
  final quotes = <Map<String, String>>[].obs;
  final currentQuoteIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['theme'] != null) {
      currentTheme.value = args['theme'];
      _loadQuotes();
    }
  }

  void _loadQuotes() {
    quotes.value = _quoteService.getQuotesByTheme(currentTheme.value);
    if (quotes.isNotEmpty) {
      currentQuoteIndex.value = 0;
    }
  }

  void nextQuote() {
    if (quotes.isEmpty) return;
    currentQuoteIndex.value = (currentQuoteIndex.value + 1) % quotes.length;
  }

  void previousQuote() {
    if (quotes.isEmpty) return;
    currentQuoteIndex.value =
        (currentQuoteIndex.value - 1 + quotes.length) % quotes.length;
  }

  Map<String, String> get currentQuote {
    if (quotes.isEmpty) {
      return {'content': '', 'author': ''};
    }
    return quotes[currentQuoteIndex.value];
  }
}
