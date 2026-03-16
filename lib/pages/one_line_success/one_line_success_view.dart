import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'one_line_success_logic.dart';

class OneLineSuccessView extends GetView<OneLineSuccessLogic> {
  const OneLineSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onClose,
      child: Scaffold(
        backgroundColor: controller.bgColor,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    controller.content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F0F0F),
                      height: 1.8,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    controller.author,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    controller.date,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Recorded, tap anywhere to continue',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
