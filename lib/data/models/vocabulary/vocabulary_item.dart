import 'package:json_annotation/json_annotation.dart';

part 'vocabulary_item.g.dart';

@JsonSerializable()
class VocabularyItem {
  final String id;
  final String word;
  final String meaning;
  final String? pronunciation;
  final List<String> exampleSentences;
  final String? partOfSpeech;
  final String? category;
  final bool isMemorized;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? lastReviewedAt;

  const VocabularyItem({
    required this.id,
    required this.word,
    required this.meaning,
    this.pronunciation,
    this.exampleSentences = const [],
    this.partOfSpeech,
    this.category,
    this.isMemorized = false,
    this.isDefault = false,
    required this.createdAt,
    this.lastReviewedAt,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) =>
      _$VocabularyItemFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyItemToJson(this);

  VocabularyItem copyWith({
    String? id,
    String? word,
    String? meaning,
    String? pronunciation,
    List<String>? exampleSentences,
    String? partOfSpeech,
    String? category,
    bool? isMemorized,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? lastReviewedAt,
  }) {
    return VocabularyItem(
      id: id ?? this.id,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      pronunciation: pronunciation ?? this.pronunciation,
      exampleSentences: exampleSentences ?? this.exampleSentences,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      category: category ?? this.category,
      isMemorized: isMemorized ?? this.isMemorized,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'pronunciation': pronunciation,
      'example_sentences': exampleSentences.join('|||'),
      'part_of_speech': partOfSpeech,
      'category': category,
      'is_memorized': isMemorized ? 1 : 0,
      'is_default': isDefault ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'last_reviewed_at': lastReviewedAt?.millisecondsSinceEpoch,
    };
  }

  factory VocabularyItem.fromMap(Map<String, dynamic> map) {
    return VocabularyItem(
      id: map['id'] as String,
      word: map['word'] as String,
      meaning: map['meaning'] as String,
      pronunciation: map['pronunciation'] as String?,
      exampleSentences: map['example_sentences'] != null
          ? (map['example_sentences'] as String).split('|||')
          : [],
      partOfSpeech: map['part_of_speech'] as String?,
      category: map['category'] as String?,
      isMemorized: (map['is_memorized'] as int) == 1,
      isDefault: (map['is_default'] as int) == 1,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      lastReviewedAt: map['last_reviewed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_reviewed_at'] as int)
          : null,
    );
  }
}
