// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyItem _$VocabularyItemFromJson(Map<String, dynamic> json) =>
    VocabularyItem(
      id: json['id'] as String,
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      pronunciation: json['pronunciation'] as String?,
      exampleSentences: (json['exampleSentences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      partOfSpeech: json['partOfSpeech'] as String?,
      category: json['category'] as String?,
      isMemorized: json['isMemorized'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastReviewedAt: json['lastReviewedAt'] == null
          ? null
          : DateTime.parse(json['lastReviewedAt'] as String),
    );

Map<String, dynamic> _$VocabularyItemToJson(VocabularyItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'meaning': instance.meaning,
      'pronunciation': instance.pronunciation,
      'exampleSentences': instance.exampleSentences,
      'partOfSpeech': instance.partOfSpeech,
      'category': instance.category,
      'isMemorized': instance.isMemorized,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastReviewedAt': instance.lastReviewedAt?.toIso8601String(),
    };
