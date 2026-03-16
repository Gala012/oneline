import 'dart:math';
import '../db_one_line/db_one_line_entity.dart';
import '../db_one_line/data.dart';
import 'package:get/get.dart';
class QuoteService extends GetxService {
  final DbOneLine _db = Get.find<DbOneLine>();
  final _random = Random();
  final List<String> themes = [
    'Love',
    'Solitude',
    'Growth',
    'Healing',
    'Courage',
    'Wisdom',
  ];
  final Map<String, List<Map<String, dynamic>>> _themeQuotes = {
    'Love': [
      {
        'content': 'Love is not about possession. Love is about appreciation.',
        'author': 'Osho',
      },
      {
        'content': 'The greatest happiness of life is the conviction that we are loved.',
        'author': 'Victor Hugo',
      },
      {
        'content': 'Love recognizes no barriers.',
        'author': 'Maya Angelou',
      },
    ],
    'Solitude': [
      {
        'content': 'In solitude, be a multitude to thyself.',
        'author': 'Tibullus',
      },
      {
        'content': 'Solitude is where one discovers one is not alone.',
        'author': 'Marty Rubin',
      },
      {
        'content': 'Loneliness adds beauty to life. It puts a special burn on sunsets.',
        'author': 'Henry Rollins',
      },
    ],
    'Growth': [
      {
        'content': 'Growth is painful. Change is painful. But nothing is as painful as staying stuck.',
        'author': 'Mandy Hale',
      },
      {
        'content': 'The only impossible journey is the one you never begin.',
        'author': 'Tony Robbins',
      },
      {
        'content': 'Life begins at the end of your comfort zone.',
        'author': 'Neale Donald Walsch',
      },
    ],
    'Healing': [
      {
        'content': 'Healing takes time, and asking for help is a courageous step.',
        'author': 'Mariska Hargitay',
      },
      {
        'content': 'The wound is the place where the light enters you.',
        'author': 'Rumi',
      },
      {
        'content': 'Healing is not linear.',
        'author': 'Unknown',
      },
    ],
    'Courage': [
      {
        'content': 'Courage is not the absence of fear, but rather the judgment that something else is more important.',
        'author': 'Ambrose Redmoon',
      },
      {
        'content': 'You gain strength, courage, and confidence by every experience in which you really stop to look fear in the face.',
        'author': 'Eleanor Roosevelt',
      },
      {
        'content': 'Courage is resistance to fear, mastery of fear - not absence of fear.',
        'author': 'Mark Twain',
      },
    ],
    'Wisdom': [
      {
        'content': 'Knowing yourself is the beginning of all wisdom.',
        'author': 'Aristotle',
      },
      {
        'content': 'The only true wisdom is in knowing you know nothing.',
        'author': 'Socrates',
      },
      {
        'content': 'Wisdom is not a product of schooling but of the lifelong attempt to acquire it.',
        'author': 'Albert Einstein',
      },
    ],
  };
  final List<Map<String, dynamic>> _dailyQuotes = [
    {
      'content': 'Everything we see is a perspective, not the truth.',
      'author': 'Marcus Aurelius',
    },
    {
      'content': 'The only way to do great work is to love what you do.',
      'author': 'Steve Jobs',
    },
    {
      'content': 'Life is what happens when you\'re busy making other plans.',
      'author': 'John Lennon',
    },
    {
      'content': 'Be yourself; everyone else is already taken.',
      'author': 'Oscar Wilde',
    },
    {
      'content': 'The journey of a thousand miles begins with one step.',
      'author': 'Lao Tzu',
    },
    {
      'content': 'In the middle of difficulty lies opportunity.',
      'author': 'Albert Einstein',
    },
    {
      'content': 'Not all those who wander are lost.',
      'author': 'J.R.R. Tolkien',
    },
    {
      'content': 'What you seek is seeking you.',
      'author': 'Rumi',
    },
    {
      'content': 'The mind is everything. What you think you become.',
      'author': 'Buddha',
    },
    {
      'content': 'Simplicity is the ultimate sophistication.',
      'author': 'Leonardo da Vinci',
    },
    {
      'content': 'To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.',
      'author': 'Ralph Waldo Emerson',
    },
    {
      'content': 'The greatest sound is silence, the greatest form is formless.',
      'author': 'Laozi',
    },
    {
      'content': 'Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.',
      'author': 'Buddha',
    },
    {
      'content': 'Knowing yourself is the beginning of all wisdom.',
      'author': 'Aristotle',
    },
    {
      'content': 'The unexamined life is not worth living.',
      'author': 'Socrates',
    },
  ];
  final Map<String, List<Map<String, dynamic>>> _moodQuotes = {
    'Anxious': [
      {
        'content': 'Worry does not empty tomorrow of its sorrow, it empties today of its strength.',
        'author': 'Corrie Ten Boom',
      },
      {
        'content': 'Nothing in life is to be feared, it is only to be understood.',
        'author': 'Marie Curie',
      },
      {
        'content': 'You are braver than you believe, stronger than you seem, and smarter than you think.',
        'author': 'A.A. Milne',
      },
    ],
    'Calm': [
      {
        'content': 'Peace comes from within. Do not seek it without.',
        'author': 'Buddha',
      },
      {
        'content': 'The greatest sound is silence, the greatest form is formless.',
        'author': 'Laozi',
      },
      {
        'content': 'In the midst of movement and chaos, keep stillness inside of you.',
        'author': 'Deepak Chopra',
      },
    ],
    'Anticipate': [
      {
        'content': 'The future belongs to those who believe in the beauty of their dreams.',
        'author': 'Eleanor Roosevelt',
      },
      {
        'content': 'Hope is being able to see that there is light despite all of the darkness.',
        'author': 'Desmond Tutu',
      },
      {
        'content': 'Every moment is a fresh beginning.',
        'author': 'T.S. Eliot',
      },
    ],
    'Lost': [
      {
        'content': 'Not all those who wander are lost.',
        'author': 'J.R.R. Tolkien',
      },
      {
        'content': 'It is only when we truly know and understand that we have a limited time on earth that we will begin to live each day to the fullest.',
        'author': 'Elisabeth Kübler-Ross',
      },
      {
        'content': 'The cave you fear to enter holds the treasure you seek.',
        'author': 'Joseph Campbell',
      },
    ],
    'Joyful': [
      {
        'content': 'Happiness is not something ready made. It comes from your own actions.',
        'author': 'Dalai Lama',
      },
      {
        'content': 'The most wasted of all days is one without laughter.',
        'author': 'E.E. Cummings',
      },
      {
        'content': 'Joy is the simplest form of gratitude.',
        'author': 'Karl Barth',
      },
    ],
    'Tired': [
      {
        'content': 'Rest when you\'re weary. Refresh and renew yourself, your body, your mind, your spirit.',
        'author': 'Ralph Marston',
      },
      {
        'content': 'Almost everything will work again if you unplug it for a few minutes, including you.',
        'author': 'Anne Lamott',
      },
      {
        'content': 'Sometimes the most productive thing you can do is relax.',
        'author': 'Mark Black',
      },
    ],
  };
  final List<String> _goodnightMessages = [
    'Go to sleep, everything exists in dreams.',
    'Rest well, tomorrow is a new beginning.',
    'Close your eyes, let the world fade away.',
    'Good night, may your dreams be sweet.',
    'Sleep tight, the stars are watching over you.',
  ];
  Map<String, String> getRandomDailyQuote() {
    final quote = _dailyQuotes[_random.nextInt(_dailyQuotes.length)];
    return {
      'content': quote['content'] as String,
      'author': '-- ${quote['author']}',
    };
  }
  Map<String, String>? getRandomMoodQuote(String mood, {String? excludeContent}) {
    final quotes = _moodQuotes[mood];
    if (quotes == null || quotes.isEmpty) {
      final fallback = _dailyQuotes[_random.nextInt(_dailyQuotes.length)];
      return {
        'content': fallback['content'] as String,
        'author': '-- ${fallback['author']}',
      };
    }
    var availableQuotes = quotes;
    if (excludeContent != null) {
      availableQuotes = quotes.where((q) => q['content'] != excludeContent).toList();
      if (availableQuotes.isEmpty) {
        availableQuotes = quotes;
      }
    }
    final quote = availableQuotes[_random.nextInt(availableQuotes.length)];
    return {
      'content': quote['content'] as String,
      'author': '-- ${quote['author']}',
    };
  }
  String getRandomGoodnightMessage() {
    return _goodnightMessages[_random.nextInt(_goodnightMessages.length)];
  }
  Future<void> initializePresetQuotes() async {
    final existingQuotes = await _db.getQuotes();
    if (existingQuotes.isNotEmpty) {
      return;
    }
    for (var quote in _dailyQuotes) {
      await _db.insertQuote(Quote(
        content: quote['content'] as String,
        author: quote['author'] as String,
        type: 'daily',
      ));
    }
    _moodQuotes.forEach((mood, quotes) async {
      for (var quote in quotes) {
        await _db.insertQuote(Quote(
          content: quote['content'] as String,
          author: quote['author'] as String,
          moodTag: mood,
          type: 'mood',
        ));
      }
    });
    _themeQuotes.forEach((theme, quotes) async {
      for (var quote in quotes) {
        await _db.insertQuote(Quote(
          content: quote['content'] as String,
          author: quote['author'] as String,
          theme: theme,
          type: 'theme',
        ));
      }
    });
  }
  List<Map<String, String>> getQuotesByTheme(String theme) {
    final quotes = _themeQuotes[theme] ?? [];
    return quotes.map((q) => {
      'content': q['content'] as String,
      'author': '-- ${q['author']}',
    }).toList();
  }
}
