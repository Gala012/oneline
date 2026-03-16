import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'one_line_home_logic.dart';

class OneLineHomeView extends GetView<OneLineHomeLogic> {
  const OneLineHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _buildBanner(),
                  SizedBox(height: 24.h),
                  _buildQuickActions(),
                  SizedBox(height: 20.h),
                  _buildDailyQuote(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          Obx(
            () => controller.showGoodnight.value
                ? _buildGoodnightOverlay()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 2.4,
          child: PageView.builder(
            onPageChanged: controller.onBannerChanged,
            itemCount: controller.banners.length,
            itemBuilder: (context, index) {
              final item = controller.banners[index];
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: index == 0
                      ? const Color(0xFFE8EDE8)
                      : index == 1
                      ? const Color(0xFFE5E5E5)
                      : const Color(0xFFE0DDE0),
                  borderRadius: BorderRadius.circular(16.w),
                ),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        item['title']!,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F0F0F),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Flexible(
                      child: Text(
                        item['subtitle']!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF6B7280),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: controller.currentBannerIndex.value == i ? 8.w : 6.w,
                height: controller.currentBannerIndex.value == i ? 8.w : 6.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.currentBannerIndex.value == i
                      ? const Color(0xFF0F0F0F)
                      : const Color(0xFFE5E7EB),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'label': 'Compose',
        'icon': Icons.edit_outlined,
        'gradientColors': [Color(0xFFF5F5F5), Color(0xFFEFEFEF)],
        'iconColor': 0xFF6366F1,
      },
      {
        'label': 'Explore',
        'icon': Icons.explore_outlined,
        'gradientColors': [Color(0xFFE8F5E9), Color(0xFFD4E9D6)],
        'iconColor': 0xFF10B981,
      },
      {
        'label': 'Goodnight',
        'icon': Icons.nights_stay_outlined,
        'gradientColors': [Color(0xFFEDE9FE), Color(0xFFDDD6FE)],
        'iconColor': 0xFF8B5CF6,
      },
    ];
    return Row(
      children: actions.asMap().entries.map((entry) {
        final action = entry.value;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              final label = action['label'] as String;
              if (label == 'Compose') {
                Get.toNamed('/one_compose');
              } else if (label == 'Explore') {
                Get.toNamed('/one_explore');
              } else if (label == 'Goodnight') {
                controller.toggleGoodnight();
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: entry.key < 2 ? 12.w : 0),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: action['gradientColors'] as List<Color>,
                ),
                borderRadius: BorderRadius.circular(16.w),
                boxShadow: [
                  BoxShadow(
                    color: (action['gradientColors'] as List<Color>)[1]
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      size: 24.sp,
                      color: Color(action['iconColor'] as int),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    action['label'] as String,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F0F0F),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDailyQuote() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0F0F),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Daily Quote',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF0F0F0F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: controller.onRefreshQuote,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      size: 18.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u201c\u201c',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: const Color(0xFFE5E7EB),
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Obx(
                    () => Text(
                      controller.dailyQuote['content'] ?? '',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F0F0F),
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
                Text(
                  '\u201d\u201d',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: const Color(0xFFE5E7EB),
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Align(
              alignment: Alignment.centerRight,
              child: Obx(
                () => Text(
                  controller.dailyQuote['author'] ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Container(height: 1, color: const Color(0xFFF3F4F6)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: 'Favorite',
                  isActive: controller.isFavorited,
                  activeColor: const Color(0xFFEF4444),
                  onTap: controller.toggleFavorite,
                ),
                _buildActionButton(
                  icon: Icons.content_copy_rounded,
                  label: 'Copy',
                  onTap: controller.copyQuote,
                ),
                _buildActionButton(
                  icon: Icons.send_rounded,
                  activeIcon: Icons.check_circle_rounded,
                  label: 'Forward',
                  isActive: controller.isForwarded,
                  activeColor: const Color(0xFF10B981),
                  onTap: controller.onForwardQuote,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    IconData? activeIcon,
    required String label,
    RxBool? isActive,
    Color? activeColor,
    bool isEnabled = true,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isEnabled
                ? const Color(0xFFFAFAFA)
                : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isActive != null
                  ? Obx(
                      () => Icon(
                        isActive.value ? (activeIcon ?? icon) : icon,
                        size: 20.sp,
                        color: isActive.value
                            ? (activeColor ?? const Color(0xFF6B7280))
                            : (isEnabled
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFFD1D5DB)),
                      ),
                    )
                  : Icon(
                      icon,
                      size: 20.sp,
                      color: isEnabled
                          ? const Color(0xFF6B7280)
                          : const Color(0xFFD1D5DB),
                    ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isEnabled
                      ? const Color(0xFF6B7280)
                      : const Color(0xFFD1D5DB),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoodnightOverlay() {
    return GestureDetector(
      onTap: controller.toggleGoodnight,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E21), Color(0xFF161B33), Color(0xFF1C1F3A)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: 60.h, left: 30.w, child: _buildStar(4.w, 0.8)),
            Positioned(top: 90.h, left: 80.w, child: _buildStar(2.5.w, 0.5)),
            Positioned(top: 50.h, right: 50.w, child: _buildStar(3.w, 0.7)),
            Positioned(top: 120.h, right: 30.w, child: _buildStar(2.w, 0.4)),
            Positioned(top: 180.h, left: 20.w, child: _buildStar(2.w, 0.6)),
            Positioned(bottom: 160.h, left: 40.w, child: _buildStar(3.w, 0.5)),
            Positioned(bottom: 200.h, right: 60.w, child: _buildStar(4.w, 0.7)),
            Positioned(
              bottom: 120.h,
              right: 25.w,
              child: _buildStar(2.5.w, 0.6),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFFFFF5C3), Color(0xFFFFD97D)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFFFD97D,
                          ).withValues(alpha: 0.35),
                          blurRadius: 28,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.nights_stay_rounded,
                      size: 36.sp,
                      color: const Color(0xFF2D2A1E),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 28.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(20.w),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.format_quote_rounded,
                            size: 28.sp,
                            color: const Color(
                              0xFFFFD97D,
                            ).withValues(alpha: 0.7),
                          ),
                          SizedBox(height: 12.h),
                          Obx(
                            () => Text(
                              controller.goodnightMessage.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.92),
                                height: 1.7,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20.w),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 14.sp,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Tap anywhere to close',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withValues(alpha: 0.45),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(double size, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
