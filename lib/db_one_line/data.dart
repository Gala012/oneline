import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_one_line_entity.dart';

class DbOneLine extends GetxService {
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'one_line.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE quotes ADD COLUMN theme TEXT');
      await db.execute('ALTER TABLE favorite_quotes ADD COLUMN tags TEXT');
      await db.execute('ALTER TABLE original_quotes ADD COLUMN tags TEXT');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        author TEXT NOT NULL,
        mood_tag TEXT,
        type TEXT NOT NULL,
        theme TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE favorite_quotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        author TEXT NOT NULL,
        saved_at TEXT NOT NULL,
        tags TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE original_quotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        author TEXT NOT NULL,
        published_at TEXT NOT NULL,
        type TEXT NOT NULL,
        bg_color TEXT NOT NULL,
        tags TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE mood_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood TEXT NOT NULL,
        recorded_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nickname TEXT NOT NULL,
        bio TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE app_state (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        last_publish_date TEXT,
        last_checkin_date TEXT,
        streak_days INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.insert('app_state', {'streak_days': 0});
    await db.insert('user_profile', {
      'nickname': 'Traveler',
      'bio': 'Recording every moment of life',
    });
  }

  Future<List<Quote>> getQuotes({String? type, String? moodTag}) async {
    try {
      final db = await database;
      String whereClause = '';
      List<dynamic> whereArgs = [];
      if (type != null) {
        whereClause = 'type = ?';
        whereArgs.add(type);
      }
      if (moodTag != null) {
        if (whereClause.isNotEmpty) {
          whereClause += ' AND mood_tag LIKE ?';
        } else {
          whereClause = 'mood_tag LIKE ?';
        }
        whereArgs.add('%$moodTag%');
      }
      final result = await db.query(
        'quotes',
        where: whereClause.isNotEmpty ? whereClause : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      );
      return result.map((map) => Quote.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Quote>> getQuotesByTheme(String theme) async {
    try {
      final db = await database;
      final result = await db.query(
        'quotes',
        where: 'theme = ?',
        whereArgs: [theme],
      );
      return result.map((map) => Quote.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FavoriteQuote>> searchFavoriteQuotes(String keyword) async {
    try {
      final db = await database;
      final result = await db.query(
        'favorite_quotes',
        where: 'content LIKE ? OR author LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%'],
        orderBy: 'saved_at DESC, id DESC',
      );
      return result.map((map) => FavoriteQuote.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<OriginalQuote>> searchOriginalQuotes(String keyword) async {
    try {
      final db = await database;
      final result = await db.query(
        'original_quotes',
        where: 'content LIKE ? OR author LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%'],
        orderBy: 'published_at DESC, id DESC',
      );
      return result.map((map) => OriginalQuote.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FavoriteQuote>> getFavoriteQuotesByTags(List<String> tags) async {
    try {
      final db = await database;
      String whereClause = tags.map((tag) => 'tags LIKE ?').join(' OR ');
      List<String> whereArgs = tags.map((tag) => '%$tag%').toList();
      final result = await db.query(
        'favorite_quotes',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'saved_at DESC, id DESC',
      );
      return result.map((map) => FavoriteQuote.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<OriginalQuote>> getOriginalQuotesByTags(List<String> tags) async {
    try {
      final db = await database;
      String whereClause = tags.map((tag) => 'tags LIKE ?').join(' OR ');
      List<String> whereArgs = tags.map((tag) => '%$tag%').toList();
      final result = await db.query(
        'original_quotes',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'published_at DESC, id DESC',
      );
      return result.map((map) => OriginalQuote.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> updateFavoriteQuote(FavoriteQuote quote) async {
    try {
      final db = await database;
      return await db.update(
        'favorite_quotes',
        quote.toMap(),
        where: 'id = ?',
        whereArgs: [quote.id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<int> updateOriginalQuote(OriginalQuote quote) async {
    try {
      final db = await database;
      return await db.update(
        'original_quotes',
        quote.toMap(),
        where: 'id = ?',
        whereArgs: [quote.id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<int> insertQuote(Quote quote) async {
    try {
      final db = await database;
      return await db.insert('quotes', quote.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<List<FavoriteQuote>> getFavoriteQuotes() async {
    try {
      final db = await database;
      final result = await db.query(
        'favorite_quotes',
        orderBy: 'saved_at DESC, id DESC',
      );
      return result.map((map) => FavoriteQuote.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> insertFavoriteQuote(FavoriteQuote quote) async {
    try {
      final db = await database;
      return await db.insert('favorite_quotes', quote.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<int> deleteFavoriteQuote(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'favorite_quotes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<FavoriteQuote?> findFavoriteQuote(String content) async {
    try {
      final db = await database;
      final result = await db.query(
        'favorite_quotes',
        where: 'content = ?',
        whereArgs: [content],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return FavoriteQuote.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  Future<OriginalQuote?> findForwardedQuote(String content) async {
    try {
      final db = await database;
      final result = await db.query(
        'original_quotes',
        where: 'content = ? AND type = ?',
        whereArgs: [content, 'forward'],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return OriginalQuote.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  Future<List<OriginalQuote>> getOriginalQuotes() async {
    try {
      final db = await database;
      final result = await db.query(
        'original_quotes',
        orderBy: 'published_at DESC, id DESC',
      );
      return result.map((map) => OriginalQuote.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> insertOriginalQuote(OriginalQuote quote) async {
    try {
      final db = await database;
      return await db.insert('original_quotes', quote.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<int> deleteOriginalQuote(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'original_quotes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<List<MoodLog>> getMoodLogs() async {
    try {
      final db = await database;
      final result = await db.query(
        'mood_logs',
        orderBy: 'recorded_at DESC, id DESC',
      );
      return result.map((map) => MoodLog.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> insertMoodLog(MoodLog log) async {
    try {
      final db = await database;
      return await db.insert('mood_logs', log.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<UserProfile?> getUserProfile() async {
    try {
      final db = await database;
      final result = await db.query('user_profile', limit: 1);
      if (result.isEmpty) return null;
      return UserProfile.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateUserProfile(UserProfile profile) async {
    try {
      final db = await database;
      return await db.update(
        'user_profile',
        profile.toMap(),
        where: 'id = ?',
        whereArgs: [profile.id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<AppState?> getAppState() async {
    try {
      final db = await database;
      final result = await db.query('app_state', limit: 1);
      if (result.isEmpty) return null;
      return AppState.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateAppState(AppState state) async {
    try {
      final db = await database;
      return await db.update(
        'app_state',
        state.toMap(),
        where: 'id = ?',
        whereArgs: [state.id],
      );
    } catch (e) {
      return 0;
    }
  }
}
