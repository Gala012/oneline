import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/index.dart';

class OneLineSuccessLogic extends GetxController {
  late String content;
  late String author;
  late String date;
  late Color bgColor;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      content = args['content'] as String? ?? '';
      author = args['author'] as String? ?? '';
      final dateTime = args['date'] as String?;
      if (dateTime != null) {
        final dt = DateTime.tryParse(dateTime);
        if (dt != null) {
          date =
              '${dt.year} · ${dt.month.toString().padLeft(2, '0')} · ${dt.day.toString().padLeft(2, '0')}';
        } else {
          date = extractDateFromDateTime(dateTime);
          final parts = date.split('-');
          if (parts.length == 3) {
            date = '${parts[0]} · ${parts[1]} · ${parts[2]}';
          }
        }
      } else {
        final now = DateTime.now();
        date =
            '${now.year} · ${now.month.toString().padLeft(2, '0')} · ${now.day.toString().padLeft(2, '0')}';
      }
      final colorValue = args['bgColor'] as String?;
      if (colorValue != null) {
        try {
          bgColor = Color(int.parse(colorValue));
        } catch (e) {
          bgColor = Colors.white;
        }
      } else {
        bgColor = Colors.white;
      }
    }
  }

  void onClose() {
    Get.back();
  }
}
