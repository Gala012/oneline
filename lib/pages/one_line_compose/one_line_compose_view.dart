import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'one_line_compose_logic.dart';

class OneLineComposeView extends GetView<OneLineComposeLogic> {
  const OneLineComposeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Compose'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              _buildInspirationButton(),
              Obx(
                () => controller.showInspiration.value
                    ? _buildInspirationCard()
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: 12.h),
              Expanded(child: _buildTextArea()),
              SizedBox(height: 20.h),
              _buildColorPicker(),
              SizedBox(height: 20.h),
              _buildRecordButton(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspirationButton() {
    return GestureDetector(
      onTap: controller.toggleInspiration,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(color: const Color(0xFFFFE799), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 18.sp,
              color: const Color(0xFFD97706),
            ),
            SizedBox(width: 6.w),
            Text(
              'Need Inspiration?',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFFD97706),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInspirationCard() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    controller.inspirationText.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF0F0F0F),
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: controller.refreshInspiration,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: Icon(
                    Icons.refresh_rounded,
                    size: 16.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea() {
    return Obx(
      () => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: controller.selectedBgColor,
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        padding: EdgeInsets.all(20.w),
        child: Stack(
          children: [
            TextField(
              maxLength: 50,
              maxLines: null,
              expands: true,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              onChanged: controller.onTextChanged,
              style: TextStyle(
                fontSize: 18.sp,
                color: const Color(0xFF0F0F0F),
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: 'Leave your thoughts here...',
                hintStyle: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFFCECECE),
                ),
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Obx(
                () => Text(
                  '${controller.text.value.length}/50',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: controller.text.value.length >= 50
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 48.w,
              child: Obx(
                () => Text(
                  '-- ${controller.nickname.value}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.bgColors.length,
          (index) => GestureDetector(
            onTap: () => controller.selectColor(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              width: controller.selectedColorIndex.value == index ? 40.w : 32.w,
              height: controller.selectedColorIndex.value == index
                  ? 40.w
                  : 32.w,
              decoration: BoxDecoration(
                color: controller.bgColors[index],
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.selectedColorIndex.value == index
                      ? const Color(0xFF0F0F0F)
                      : const Color(0xFFE5E7EB),
                  width: controller.selectedColorIndex.value == index ? 2 : 1,
                ),
                boxShadow: controller.selectedColorIndex.value == index
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordButton() {
    return Obx(
      () => GestureDetector(
        onTap: controller.canRecord ? controller.onRecord : null,
        child: Container(
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            color: controller.canRecord
                ? const Color(0xFF0F0F0F)
                : const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(26.w),
          ),
          alignment: Alignment.center,
          child: Text(
            'Record',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: controller.canRecord
                  ? Colors.white
                  : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }
}
