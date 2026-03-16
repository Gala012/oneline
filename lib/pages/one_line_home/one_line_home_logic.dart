import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../db_one_line/data.dart';
import '../../db_one_line/db_one_line_entity.dart';
import '../../services/quote_service.dart';
import '../../utils/index.dart';

class OneLineHomeLogic extends GetxController {
  final DbOneLine _db = Get.find<DbOneLine>();
  final QuoteService _quoteService = Get.find<QuoteService>();
  final currentBannerIndex = 0.obs;
  final isFavorited = false.obs;
  final isForwarded = false.obs;
  final showGoodnight = false.obs;
  final streakDays = 0.obs;
  final goodnightMessage = ''.obs;
  final banners = <Map<String, String>>[
    {
      'title': 'Minimal Living',
      'subtitle': 'Less is more, return to simplicity',
    },
    {'title': 'Daily Reading', 'subtitle': 'Find strength in words'},
  ].obs;
  final dailyQuote = <String, String>{}.obs;
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadDailyQuote();
    await _loadAppState();
    await _checkFavoriteStatus();
    await _checkForwardedStatus();
    _updateBanners();
  }

  Future<void> _loadDailyQuote() async {
    final quote = _quoteService.getRandomDailyQuote();
    dailyQuote.value = quote;
  }

  Future<void> _loadAppState() async {
    try {
      final state = await _db.getAppState();
      if (state != null) {
        streakDays.value = state.streakDays;
      }
    } catch (e) {
      errorToast('Failed to load data');
    }
  }

  void _updateBanners() {
    final streakBanner = streakDays.value > 0
        ? {
            'title': 'Streak: ${streakDays.value} Days',
            'subtitle': 'Keep going, you\'re doing great!',
          }
        : {'title': 'Start Today', 'subtitle': 'Write your first sentence'};
    banners.value = [
      {
        'title': 'Minimal Living',
        'subtitle': 'Less is more, return to simplicity',
      },
      {'title': 'Daily Reading', 'subtitle': 'Find strength in words'},
      streakBanner,
    ];
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final content = dailyQuote['content'];
      if (content == null) return;
      final favorite = await _db.findFavoriteQuote(content);
      isFavorited.value = favorite != null;
    } catch (e) {
      isFavorited.value = false;
    }
  }

  Future<void> _checkForwardedStatus() async {
    try {
      final content = dailyQuote['content'];
      if (content == null) return;
      final forwarded = await _db.findForwardedQuote(content);
      isForwarded.value = forwarded != null;
    } catch (e) {
      isForwarded.value = false;
    }
  }

  void onBannerChanged(int index) {
    currentBannerIndex.value = index;
  }

  Future<void> onRefreshQuote() async {
    try {
      await _loadDailyQuote();
      await _checkFavoriteStatus();
      await _checkForwardedStatus();
      successToast('Quote refreshed');
    } catch (e) {
      errorToast('Failed to refresh quote');
    }
  }

  Future<void> toggleFavorite() async {
    try {
      final content = dailyQuote['content'];
      final author = dailyQuote['author'];
      if (content == null || author == null) {
        errorToast('No quote to favorite');
        return;
      }
      if (isFavorited.value) {
        final favorite = await _db.findFavoriteQuote(content);
        if (favorite?.id != null) {
          await _db.deleteFavoriteQuote(favorite!.id!);
          isFavorited.value = false;
          successToast('Removed from favorites');
        }
      } else {
        final favorite = FavoriteQuote(
          content: content,
          author: author,
          savedAt: DateTime.now().toString(),
        );
        await _db.insertFavoriteQuote(favorite);
        isFavorited.value = true;
        successToast('Added to favorites');
      }
    } catch (e) {
      errorToast('Failed to update favorite');
    }
  }

  Future<void> onForwardQuote() async {
    try {
      if (isForwarded.value) {
        errorToast('Quote already forwarded');
        return;
      }
      final content = dailyQuote['content'];
      final author = dailyQuote['author'];
      if (content == null || author == null) {
        errorToast('No quote to forward');
        return;
      }
      final today = getDateString(DateTime.now());
      final originalQuote = OriginalQuote(
        content: content,
        author: author,
        publishedAt: today,
        type: 'forward',
        bgColor: '0xFFFFFFFF',
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
        streakDays.value = newStreakDays;
        _updateBanners();
      }
      isForwarded.value = true;
      successToast('Quote forwarded successfully');
    } catch (e) {
      errorToast('Failed to forward quote');
    }
  }

  Future<void> copyQuote() async {
    try {
      final content = dailyQuote['content'];
      final author = dailyQuote['author'];
      if (content == null) {
        errorToast('No quote to copy');
        return;
      }
      final text = author != null && author.isNotEmpty
          ? '$content\n— $author'
          : content;
      await Clipboard.setData(ClipboardData(text: text));
      successToast('Copied to clipboard');
    } catch (e) {
      errorToast('Failed to copy');
    }
  }

  void toggleGoodnight() {
    if (!showGoodnight.value) {
      goodnightMessage.value = _quoteService.getRandomGoodnightMessage();
    }
    showGoodnight.value = !showGoodnight.value;
  }
}
