import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/calendar.dart';
import 'one_line_mood_calendar_logic.dart';

class OneLineMoodCalendarView extends GetView<OneLineMoodCalendarLogic> {
  const OneLineMoodCalendarView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          controller.onClose();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        appBar: AppBar(
          title: Text('Mood Calendar', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF1C1C1E),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: controller.onClose,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              _buildCalendar(),
              SizedBox(height: 24.h),
              _buildSelectedDayMoods(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Obx(
      () => CalendarView(
        monthTitle: controller.monthTitle,
        daysInMonth: controller.daysInMonth,
        firstWeekdayOfMonth: controller.firstWeekdayOfMonth,
        markedDates: controller.markedDates,
        onPreviousMonth: controller.goToPreviousMonth,
        onNextMonth: controller.goToNextMonth,
        isToday: controller.isToday,
        selectedDay: controller.selectedDay.value,
        onDaySelected: controller.onDaySelected,
      ),
    );
  }

  Widget _buildSelectedDayMoods() {
    return Expanded(
      child: Obx(
        () => controller.selectedDayMoods.isEmpty
            ? Center(
                child: Text(
                  controller.selectedDay.value == 0
                      ? 'Select a date to view moods'
                      : 'No mood records for this day',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mood Records',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.selectedDayMoods.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final log = controller.selectedDayMoods[index];
                          final time = DateTime.tryParse(log.recordedAt);
                          final timeStr = time != null
                              ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                              : '';
                          return Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A3A3C),
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  log.mood,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
