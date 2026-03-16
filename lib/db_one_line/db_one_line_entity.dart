class Quote {
  final int? id;
  final String content;
  final String author;
  final String? moodTag;
  final String type;
  final String? theme;
  const Quote({
    this.id,
    required this.content,
    required this.author,
    this.moodTag,
    required this.type,
    this.theme,
  });
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] as int?,
      content: map['content'] as String,
      author: map['author'] as String,
      moodTag: map['mood_tag'] as String?,
      type: map['type'] as String,
      theme: map['theme'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'content': content,
      'author': author,
      'mood_tag': moodTag,
      'type': type,
      'theme': theme,
    };
  }
}

class FavoriteQuote {
  final int? id;
  final String content;
  final String author;
  final String savedAt;
  final String? tags;
  const FavoriteQuote({
    this.id,
    required this.content,
    required this.author,
    required this.savedAt,
    this.tags,
  });
  factory FavoriteQuote.fromMap(Map<String, dynamic> map) {
    return FavoriteQuote(
      id: map['id'] as int?,
      content: map['content'] as String,
      author: map['author'] as String,
      savedAt: map['saved_at'] as String,
      tags: map['tags'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'content': content,
      'author': author,
      'saved_at': savedAt,
      'tags': tags,
    };
  }
}

class OriginalQuote {
  final int? id;
  final String content;
  final String author;
  final String publishedAt;
  final String type;
  final String bgColor;
  final String? tags;
  const OriginalQuote({
    this.id,
    required this.content,
    required this.author,
    required this.publishedAt,
    required this.type,
    required this.bgColor,
    this.tags,
  });
  factory OriginalQuote.fromMap(Map<String, dynamic> map) {
    return OriginalQuote(
      id: map['id'] as int?,
      content: map['content'] as String,
      author: map['author'] as String,
      publishedAt: map['published_at'] as String,
      type: map['type'] as String,
      bgColor: map['bg_color'] as String,
      tags: map['tags'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'content': content,
      'author': author,
      'published_at': publishedAt,
      'type': type,
      'bg_color': bgColor,
      'tags': tags,
    };
  }
}

class MoodLog {
  final int? id;
  final String mood;
  final String recordedAt;
  const MoodLog({this.id, required this.mood, required this.recordedAt});
  factory MoodLog.fromMap(Map<String, dynamic> map) {
    return MoodLog(
      id: map['id'] as int?,
      mood: map['mood'] as String,
      recordedAt: map['recorded_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'mood': mood, 'recorded_at': recordedAt};
  }
}

class UserProfile {
  final int? id;
  final String nickname;
  final String bio;
  const UserProfile({this.id, required this.nickname, required this.bio});
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int?,
      nickname: map['nickname'] as String,
      bio: map['bio'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'nickname': nickname, 'bio': bio};
  }
}

class AppState {
  final int? id;
  final String? lastPublishDate;
  final String? lastCheckinDate;
  final int streakDays;
  const AppState({
    this.id,
    this.lastPublishDate,
    this.lastCheckinDate,
    required this.streakDays,
  });
  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      id: map['id'] as int?,
      lastPublishDate: map['last_publish_date'] as String?,
      lastCheckinDate: map['last_checkin_date'] as String?,
      streakDays: map['streak_days'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'last_publish_date': lastPublishDate,
      'last_checkin_date': lastCheckinDate,
      'streak_days': streakDays,
    };
  }
}
