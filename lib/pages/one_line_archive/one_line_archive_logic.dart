import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../db_one_line/data.dart';
import '../../db_one_line/db_one_line_entity.dart';
import '../../utils/index.dart';

class OneLineArchiveLogic extends GetxController {
  final DbOneLine _db = Get.find<DbOneLine>();
  final currentTabIndex = 0.obs;
  final tabs = ['Favorites', 'Original', 'Mood'].obs;
  final nickname = 'Traveler'.obs;
  final bio = 'Recording every moment of life'.obs;
  final streakDays = 0.obs;
  final favoriteQuotes = <FavoriteQuote>[].obs;
  final originalQuotes = <OriginalQuote>[].obs;
  final moodLogs = <MoodLog>[].obs;
  final searchQuery = ''.obs;
  final isSearching = false.obs;
  void navigateToMoodCalendar() {
    Get.toNamed('/mood_calendar');
  }

  void onCardTap(OriginalQuote quote) {
    Get.toNamed(
      '/one_success',
      arguments: {
        'content': quote.content,
        'author': quote.author,
        'date': quote.publishedAt,
        'bgColor': quote.bgColor,
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await _loadUserProfile();
    await _loadAppState();
    await _loadFavorites();
    await _loadOriginals();
    await _loadMoodLogs();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _db.getUserProfile();
      if (profile != null) {
        nickname.value = profile.nickname;
        bio.value = profile.bio;
      }
    } catch (e) {
      errorToast('Failed to load profile');
    }
  }

  Future<void> _loadAppState() async {
    try {
      final state = await _db.getAppState();
      if (state != null) {
        streakDays.value = state.streakDays;
      }
    } catch (e) {
      streakDays.value = 0;
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final quotes = await _db.getFavoriteQuotes();
      favoriteQuotes.value = quotes;
    } catch (e) {
      errorToast('Failed to load favorites');
    }
  }

  Future<void> _loadOriginals() async {
    try {
      final quotes = await _db.getOriginalQuotes();
      originalQuotes.value = quotes;
    } catch (e) {
      errorToast('Failed to load originals');
    }
  }

  Future<void> _loadMoodLogs() async {
    try {
      final logs = await _db.getMoodLogs();
      moodLogs.value = logs;
    } catch (e) {
      errorToast('Failed to load mood logs');
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
    searchQuery.value = '';
    isSearching.value = false;
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
      _loadFavorites();
      _loadOriginals();
    }
  }

  Future<void> onSearchChanged(String query) async {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      await _loadFavorites();
      await _loadOriginals();
      return;
    }
    try {
      if (currentTabIndex.value == 0) {
        final results = await _db.searchFavoriteQuotes(query.trim());
        favoriteQuotes.value = results;
      } else if (currentTabIndex.value == 1) {
        final results = await _db.searchOriginalQuotes(query.trim());
        originalQuotes.value = results;
      }
    } catch (e) {
      errorToast('Search failed');
    }
  }

  Future<void> onEditNickname() async {
    final controller = TextEditingController(text: nickname.value);
    final result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Edit Nickname'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter nickname'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      try {
        final profile = await _db.getUserProfile();
        if (profile?.id != null) {
          final newProfile = UserProfile(
            id: profile!.id,
            nickname: result.trim(),
            bio: bio.value,
          );
          await _db.updateUserProfile(newProfile);
          nickname.value = result.trim();
          successToast('Nickname updated');
        }
      } catch (e) {
        errorToast('Failed to update nickname');
      }
    } else if (result != null) {
      errorToast('Nickname cannot be empty');
    }
  }

  Future<void> onEditBio() async {
    final controller = TextEditingController(text: bio.value);
    final result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Edit Bio'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter bio'),
          autofocus: true,
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      try {
        final profile = await _db.getUserProfile();
        if (profile?.id != null) {
          final newProfile = UserProfile(
            id: profile!.id,
            nickname: nickname.value,
            bio: result.trim(),
          );
          await _db.updateUserProfile(newProfile);
          bio.value = result.trim();
          successToast('Bio updated');
        }
      } catch (e) {
        errorToast('Failed to update bio');
      }
    }
  }

  Future<void> onDeleteFavorite(int id) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Remove Favorite?'),
        content: const Text('This quote will be removed from your favorites.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _db.deleteFavoriteQuote(id);
        await _loadFavorites();
        successToast('Removed from favorites');
      } catch (e) {
        errorToast('Failed to remove favorite');
      }
    }
  }

  Future<void> onDeleteOriginal(int id) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Record?'),
        content: const Text('This record will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _db.deleteOriginalQuote(id);
        await _loadOriginals();
        successToast('Record deleted');
      } catch (e) {
        errorToast('Failed to delete record');
      }
    }
  }

  Map<String, List<OriginalQuote>> get groupedOriginals {
    final grouped = <String, List<OriginalQuote>>{};
    for (var quote in originalQuotes) {
      final date = extractDateFromDateTime(quote.publishedAt);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(quote);
    }
    return grouped;
  }

  Map<String, List<MoodLog>> get groupedMoodLogs {
    final grouped = <String, List<MoodLog>>{};
    for (var log in moodLogs) {
      final date = extractDateFromDateTime(log.recordedAt);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(log);
    }
    return grouped;
  }
}
