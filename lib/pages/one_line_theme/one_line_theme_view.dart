import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'one_line_theme_logic.dart';

class OneLineThemeView extends GetView<OneLineThemeLogic> {
  const OneLineThemeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Obx(() => Text(controller.currentTheme.value)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => controller.quotes.isEmpty
            ? Center(
                child: Text(
                  'No quotes found',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(child: _buildQuoteCard()),
                    _buildNavigation(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Obx(
      () => Container(
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(20.w),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.format_quote_rounded,
              size: 32.sp,
              color: const Color(0xFFE5E7EB),
            ),
            SizedBox(height: 24.h),
            Text(
              controller.currentQuote['content'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0F0F0F),
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              controller.currentQuote['author'] ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF6B7280),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: controller.previousQuote,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20.sp,
                  color: const Color(0xFF0F0F0F),
                ),
              ),
            ),
            Text(
              '${controller.currentQuoteIndex.value + 1} / ${controller.quotes.length}',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6B7280)),
            ),
            GestureDetector(
              onTap: controller.nextQuote,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.sp,
                  color: const Color(0xFF0F0F0F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
