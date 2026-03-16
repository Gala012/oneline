import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'one_line_mood_logic.dart';

class OneLineMoodView extends GetView<OneLineMoodLogic> {
  const OneLineMoodView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Mood',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F0F0F),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Choose a color, listen to your heart',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildBubbles()),
              ],
            ),
          ),
          Obx(
            () => controller.showQuoteDialog.value
                ? _buildQuoteOverlay()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbles() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: controller.moods.map((mood) {
            final size = mood['size'] as double;
            final xRatio = mood['x'] as double;
            final yRatio = mood['y'] as double;
            final left = xRatio * constraints.maxWidth;
            final top = yRatio * constraints.maxHeight;
            return Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onTap: () => controller.onMoodTap(mood['label'] as String),
                child: Container(
                  width: size.w,
                  height: size.w,
                  decoration: BoxDecoration(
                    color: Color(mood['color'] as int),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    mood['label'] as String,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildQuoteOverlay() {
    return GestureDetector(
      onTap: controller.closeDialog,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFEFF5EF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(28.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.moodQuote['content'] ?? '',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0F0F0F),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(
                        () => Text(
                          controller.moodQuote['author'] ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(
                          () => GestureDetector(
                            onTap: controller.toggleFavorite,
                            child: Icon(
                              controller.isFavorited.value
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 22.sp,
                              color: controller.isFavorited.value
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: controller.onCopyQuote,
                          child: Icon(
                            Icons.copy_rounded,
                            size: 22.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: controller.onRefreshQuote,
                          child: Icon(
                            Icons.refresh_rounded,
                            size: 22.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: controller.closeDialog,
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 20.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
