import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/index.dart';
import 'one_line_archive_logic.dart';

class OneLineArchiveView extends GetView<OneLineArchiveLogic> {
  const OneLineArchiveView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            _buildUserInfo(),
            _buildTabBar(),
            Obx(
              () =>
                  controller.isSearching.value &&
                      controller.currentTabIndex.value < 2
                  ? _buildSearchBar()
                  : const SizedBox.shrink(),
            ),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 20.sp,
            color: const Color(0xFF9CA3AF),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF0F0F0F)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
      child: Column(
        children: [
          Obx(
            () => Container(
              width: 72.w,
              height: 72.w,
              decoration: const BoxDecoration(
                color: Color(0xFF1F1F1F),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                controller.nickname.value.isNotEmpty
                    ? controller.nickname.value[0].toUpperCase()
                    : 'T',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: controller.onEditNickname,
            child: Obx(
              () => Text(
                controller.nickname.value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F0F0F),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: controller.onEditBio,
            child: Obx(
              () => Text(
                controller.bio.value,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Text(
              'Streak: ${controller.streakDays.value} days',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Obx(
      () => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    controller.tabs.length,
                    (index) => GestureDetector(
                      onTap: () => controller.changeTab(index),
                      child: Padding(
                        padding: EdgeInsets.only(right: 32.w),
                        child: Column(
                          children: [
                            Text(
                              controller.tabs[index],
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight:
                                    controller.currentTabIndex.value == index
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: controller.currentTabIndex.value == index
                                    ? const Color(0xFF0F0F0F)
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: controller.currentTabIndex.value == index
                                  ? 24.w
                                  : 0,
                              height: 2.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F0F0F),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (controller.currentTabIndex.value == 2)
                  GestureDetector(
                    onTap: controller.navigateToMoodCalendar,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        size: 18.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                if (controller.currentTabIndex.value < 2)
                  GestureDetector(
                    onTap: controller.toggleSearch,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: controller.isSearching.value
                            ? const Color(0xFF0F0F0F)
                            : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        size: 18.sp,
                        color: controller.isSearching.value
                            ? Colors.white
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: const Color(0xFFE5E7EB), thickness: 1),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Obx(() {
      if (controller.currentTabIndex.value == 0) {
        return _buildFavoritesList();
      } else if (controller.currentTabIndex.value == 1) {
        return _buildOriginalsList();
      } else {
        return _buildMoodLogsList();
      }
    });
  }

  Widget _buildEmptyState(String message) {
    return Container(
      color: const Color(0xFFF9F9F9),
      child: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Obx(() {
      if (controller.favoriteQuotes.isEmpty) {
        return _buildEmptyState('No favorites yet');
      }
      return Container(
        color: const Color(0xFFF9F9F9),
        child: ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.favoriteQuotes.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final quote = controller.favoriteQuotes[index];
            return GestureDetector(
              onLongPress: () => controller.onDeleteFavorite(quote.id!),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.w),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.content,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F0F0F),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          quote.author,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          extractDateFromDateTime(quote.savedAt),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildOriginalsList() {
    return Obx(() {
      if (controller.originalQuotes.isEmpty) {
        return _buildEmptyState('No records yet');
      }
      final grouped = controller.groupedOriginals;
      final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
      return Container(
        color: const Color(0xFFF9F9F9),
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            final quotes = grouped[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    date.replaceAll('-', ' · '),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                ...quotes.map((quote) {
                  Color cardBgColor;
                  try {
                    cardBgColor = Color(int.parse(quote.bgColor));
                  } catch (e) {
                    cardBgColor = Colors.white;
                  }
                  return GestureDetector(
                    onTap: () => controller.onCardTap(quote),
                    onLongPress: () => controller.onDeleteOriginal(quote.id!),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(12.w),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: quote.type == 'original'
                                      ? const Color(0xFFE0F2FE)
                                      : const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(4.w),
                                ),
                                child: Text(
                                  quote.type == 'original'
                                      ? 'Original'
                                      : 'Forward',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: quote.type == 'original'
                                        ? const Color(0xFF0369A1)
                                        : const Color(0xFF92400E),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            quote.content,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF0F0F0F),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            quote.author,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 12.h),
              ],
            );
          },
        ),
      );
    });
  }

  Widget _buildMoodLogsList() {
    return Obx(() {
      if (controller.moodLogs.isEmpty) {
        return _buildEmptyState('No mood logs yet, explore the Mood tab');
      }
      final grouped = controller.groupedMoodLogs;
      final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
      return Container(
        color: const Color(0xFFF9F9F9),
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            final logs = grouped[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    date.replaceAll('-', ' · '),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: logs.map((log) {
                    final time = DateTime.tryParse(log.recordedAt);
                    final timeStr = time != null
                        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                        : '';
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.w),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        '${log.mood} · $timeStr',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF0F0F0F),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),
              ],
            );
          },
        ),
      );
    });
  }
}
