// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrammarItem _$GrammarItemFromJson(Map<String, dynamic> json) => GrammarItem(
      id: json['id'] as String,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      rules:
          (json['rules'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      exampleSentences: (json['exampleSentences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      category: json['category'] as String?,
      level: json['level'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GrammarItemToJson(GrammarItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'explanation': instance.explanation,
      'rules': instance.rules,
      'exampleSentences': instance.exampleSentences,
      'category': instance.category,
      'level': instance.level,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
    };
