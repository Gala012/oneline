import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'one_line_explore_logic.dart';

class OneLineExploreView extends GetView<OneLineExploreLogic> {
  const OneLineExploreView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Explore Themes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover quotes by theme',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(child: _buildThemeGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeGrid() {
    final icons = [
      Icons.favorite_rounded,
      Icons.self_improvement_rounded,
      Icons.trending_up_rounded,
      Icons.spa_rounded,
      Icons.flash_on_rounded,
      Icons.auto_awesome_rounded,
    ];
    final colors = [
      const Color(0xFFFFE4E6),
      const Color(0xFFDEEDFF),
      const Color(0xFFD1FAE5),
      const Color(0xFFFEF3C7),
      const Color(0xFFE0E7FF),
      const Color(0xFFFCE7F3),
    ];
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.2,
      ),
      itemCount: controller.themes.length,
      itemBuilder: (context, index) {
        final theme = controller.themes[index];
        return GestureDetector(
          onTap: () => controller.onThemeSelected(theme),
          child: Container(
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              borderRadius: BorderRadius.circular(16.w),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icons[index % icons.length],
                  size: 40.sp,
                  color: const Color(0xFF0F0F0F),
                ),
                SizedBox(height: 12.h),
                Text(
                  theme,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F0F0F),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
