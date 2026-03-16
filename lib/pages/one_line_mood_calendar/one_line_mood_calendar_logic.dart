import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../db_one_line/data.dart';
import '../../db_one_line/db_one_line_entity.dart';
import '../../utils/index.dart';

class OneLineMoodCalendarLogic extends GetxController {
  final DbOneLine _db = Get.find<DbOneLine>();
  final currentYear = DateTime.now().year.obs;
  final currentMonth = DateTime.now().month.obs;
  final selectedDay = 0.obs;
  final moodLogs = <MoodLog>[].obs;
  final selectedDayMoods = <MoodLog>[].obs;
  @override
  void onInit() {
    super.onInit();
    _loadMoodLogs();
  }

  Future<void> _loadMoodLogs() async {
    try {
      final logs = await _db.getMoodLogs();
      moodLogs.value = logs;
    } catch (e) {
      moodLogs.value = [];
    }
  }

  String get monthTitle {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[currentMonth.value - 1]} ${currentYear.value}';
  }

  int get daysInMonth {
    return DateTime(currentYear.value, currentMonth.value + 1, 0).day;
  }

  int get firstWeekdayOfMonth {
    final firstDay = DateTime(currentYear.value, currentMonth.value, 1);
    return firstDay.weekday % 7;
  }

  List<int> get markedDates {
    final marked = <int>{};
    for (var log in moodLogs) {
      final date = DateTime.tryParse(log.recordedAt);
      if (date != null &&
          date.year == currentYear.value &&
          date.month == currentMonth.value) {
        marked.add(date.day);
      }
    }
    return marked.toList();
  }

  bool isToday(int day) {
    final now = DateTime.now();
    return now.year == currentYear.value &&
        now.month == currentMonth.value &&
        now.day == day;
  }

  void onDaySelected(int day) {
    selectedDay.value = day;
    final targetDate = DateTime(currentYear.value, currentMonth.value, day);
    final targetDateStr = getDateString(targetDate);
    selectedDayMoods.value = moodLogs.where((log) {
      final logDate = extractDateFromDateTime(log.recordedAt);
      return logDate == targetDateStr;
    }).toList();
  }

  void goToPreviousMonth() {
    if (currentMonth.value == 1) {
      currentMonth.value = 12;
      currentYear.value--;
    } else {
      currentMonth.value--;
    }
    selectedDay.value = 0;
    selectedDayMoods.clear();
  }

  void goToNextMonth() {
    if (currentMonth.value == 12) {
      currentMonth.value = 1;
      currentYear.value++;
    } else {
      currentMonth.value++;
    }
    selectedDay.value = 0;
    selectedDayMoods.clear();
  }

  void onClose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    Get.back();
  }
}
