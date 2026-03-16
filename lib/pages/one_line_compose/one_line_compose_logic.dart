import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../db_one_line/data.dart';
import '../../db_one_line/db_one_line_entity.dart';
import '../../utils/index.dart';
import '../../services/inspiration_service.dart';

class OneLineComposeLogic extends GetxController {
  final DbOneLine _db = Get.find<DbOneLine>();
  final InspirationService _inspirationService = Get.find<InspirationService>();
  final text = ''.obs;
  final selectedColorIndex = 0.obs;
  final nickname = 'Traveler'.obs;
  final showInspiration = false.obs;
  final inspirationText = ''.obs;
  final bgColors = [
    Colors.white,
    const Color(0xFFF5F5F5),
    const Color(0xFFE8EDE8),
    const Color(0xFFE0EDF5),
    const Color(0xFFF5E8E8),
    const Color(0xFFE8F5E8),
  ];
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _db.getUserProfile();
      if (profile != null) {
        nickname.value = profile.nickname;
      }
    } catch (e) {
      nickname.value = 'Traveler';
    }
  }

  void onTextChanged(String value) {
    text.value = value;
  }

  void selectColor(int index) {
    selectedColorIndex.value = index;
  }

  void toggleInspiration() {
    if (!showInspiration.value) {
      inspirationText.value = _inspirationService.getRandomInspiration();
    }
    showInspiration.value = !showInspiration.value;
  }

  void refreshInspiration() {
    inspirationText.value = _inspirationService.getRandomInspiration();
  }

  Color get selectedBgColor => bgColors[selectedColorIndex.value];
  bool get canRecord => text.value.trim().isNotEmpty;
  Future<void> onRecord() async {
    if (!canRecord) {
      errorToast('Please write something first');
      return;
    }
    try {
      final today = getDateString(DateTime.now());
      final bgColorValue =
          '0x${selectedBgColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
      final originalQuote = OriginalQuote(
        content: text.value.trim(),
        author: '-- ${nickname.value}',
        publishedAt: today,
        type: 'original',
        bgColor: bgColorValue,
      );
      await _db.insertOriginalQuote(originalQuote);
      final state = await _db.getAppState();
      if (state?.id != null) {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final yesterdayStr = getDateString(yesterday);
        int newStreakDays = state!.streakDays;
        if (state.lastCheckinDate == null) {
          newStreakDays = 1;
        } else if (state.lastCheckinDate == today) {
          newStreakDays = state.streakDays;
        } else if (state.lastCheckinDate == yesterdayStr) {
          newStreakDays = state.streakDays + 1;
        } else {
          newStreakDays = 1;
        }
        final newState = AppState(
          id: state.id,
          lastPublishDate: today,
          lastCheckinDate: today,
          streakDays: newStreakDays,
        );
        await _db.updateAppState(newState);
      }
      Get.offNamed(
        '/one_success',
        arguments: {
          'content': text.value.trim(),
          'author': '-- ${nickname.value}',
          'date': today,
          'bgColor': bgColorValue,
        },
      );
    } catch (e) {
      errorToast('Failed to record');
    }
  }
}
