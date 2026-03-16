import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../db_one_line/data.dart';
import '../../db_one_line/db_one_line_entity.dart';
import '../../services/quote_service.dart';
import '../../utils/index.dart';

class OneLineMoodLogic extends GetxController {
  final DbOneLine _db = Get.find<DbOneLine>();
  final QuoteService _quoteService = Get.find<QuoteService>();
  final showQuoteDialog = false.obs;
  final selectedMood = ''.obs;
  final isFavorited = false.obs;
  final moods = [
    {
      'label': 'Anxious',
      'color': 0xFFD8C4E0,
      'size': 130.0,
      'x': 0.08,
      'y': 0.05,
    },
    {'label': 'Calm', 'color': 0xFFD4EDD8, 'size': 90.0, 'x': 0.6, 'y': 0.02},
    {
      'label': 'Anticipate',
      'color': 0xFFD8D4EE,
      'size': 95.0,
      'x': 0.2,
      'y': 0.35,
    },
    {'label': 'Lost', 'color': 0xFFBDD0E8, 'size': 130.0, 'x': 0.52, 'y': 0.28},
    {
      'label': 'Joyful',
      'color': 0xFFF5D8B8,
      'size': 120.0,
      'x': 0.05,
      'y': 0.6,
    },
    {'label': 'Tired', 'color': 0xFFD5D5D5, 'size': 95.0, 'x': 0.55, 'y': 0.63},
  ];
  final moodQuote = <String, String>{}.obs;
  Future<void> onMoodTap(String mood) async {
    try {
      selectedMood.value = mood;
      final quote = _quoteService.getRandomMoodQuote(mood);
      if (quote != null) {
        moodQuote.value = quote;
      }
      await _checkFavoriteStatus();
      final log = MoodLog(mood: mood, recordedAt: DateTime.now().toString());
      await _db.insertMoodLog(log);
      showQuoteDialog.value = true;
    } catch (e) {
      errorToast('Failed to load quote');
    }
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final content = moodQuote['content'];
      if (content == null) return;
      final favorite = await _db.findFavoriteQuote(content);
      isFavorited.value = favorite != null;
    } catch (e) {
      isFavorited.value = false;
    }
  }

  Future<void> onRefreshQuote() async {
    try {
      if (selectedMood.value.isEmpty) return;
      final currentContent = moodQuote['content'];
      final quote = _quoteService.getRandomMoodQuote(
        selectedMood.value,
        excludeContent: currentContent,
      );
      if (quote != null) {
        moodQuote.value = quote;
        await _checkFavoriteStatus();
        successToast('Quote refreshed');
      }
    } catch (e) {
      errorToast('Failed to refresh quote');
    }
  }

  Future<void> toggleFavorite() async {
    try {
      final content = moodQuote['content'];
      final author = moodQuote['author'];
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

  Future<void> onCopyQuote() async {
    try {
      final content = moodQuote['content'];
      final author = moodQuote['author'];
      if (content == null || author == null) {
        errorToast('No quote to copy');
        return;
      }
      final text = '$content\n$author';
      await Clipboard.setData(ClipboardData(text: text));
      successToast('Copied to clipboard');
    } catch (e) {
      errorToast('Failed to copy');
    }
  }

  void closeDialog() {
    showQuoteDialog.value = false;
  }
}
