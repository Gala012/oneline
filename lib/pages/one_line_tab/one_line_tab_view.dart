import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../one_line_home/one_line_home_view.dart';
import '../one_line_mood/one_line_mood_view.dart';
import '../one_line_archive/one_line_archive_view.dart';
import '../one_line_settings/one_line_settings_view.dart';
import 'one_line_tab_logic.dart';

class OneLineTabView extends GetView<OneLineTabLogic> {
  const OneLineTabView({super.key});
  @override
  Widget build(BuildContext context) {
    final pages = [
      const OneLineHomeView(),
      const OneLineMoodView(),
      const OneLineArchiveView(),
      const OneLineSettingsView(),
    ];
    return Obx(
      () => Scaffold(
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Obx(
      () => Container(
        height: 68.h,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
        ),
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24.sp),
                activeIcon: Icon(Icons.home_rounded, size: 24.sp),
                label: 'OneLine',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded, size: 24.sp),
                activeIcon: Icon(Icons.favorite_rounded, size: 24.sp),
                label: 'Mood',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded, size: 24.sp),
                activeIcon: Icon(Icons.person_rounded, size: 24.sp),
                label: 'Archive',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined, size: 24.sp),
                activeIcon: Icon(Icons.settings_rounded, size: 24.sp),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
