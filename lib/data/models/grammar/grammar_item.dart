import 'package:json_annotation/json_annotation.dart';

part 'grammar_item.g.dart';

@JsonSerializable()
class GrammarItem {
  final String id;
  final String title;
  final String explanation;
  final List<String> rules;
  final List<String> exampleSentences;
  final String? category;
  final String? level;
  final bool isDefault;
  final DateTime createdAt;

  const GrammarItem({
    required this.id,
    required this.title,
    required this.explanation,
    this.rules = const [],
    this.exampleSentences = const [],
    this.category,
    this.level,
    this.isDefault = false,
    required this.createdAt,
  });

  factory GrammarItem.fromJson(Map<String, dynamic> json) =>
      _$GrammarItemFromJson(json);

  Map<String, dynamic> toJson() => _$GrammarItemToJson(this);

  GrammarItem copyWith({
    String? id,
    String? title,
    String? explanation,
    List<String>? rules,
    List<String>? exampleSentences,
    String? category,
    String? level,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return GrammarItem(
      id: id ?? this.id,
      title: title ?? this.title,
      explanation: explanation ?? this.explanation,
      rules: rules ?? this.rules,
      exampleSentences: exampleSentences ?? this.exampleSentences,
      category: category ?? this.category,
      level: level ?? this.level,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'explanation': explanation,
      'rules': rules.join('|||'),
      'example_sentences': exampleSentences.join('|||'),
      'category': category,
      'level': level,
      'is_default': isDefault ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory GrammarItem.fromMap(Map<String, dynamic> map) {
    return GrammarItem(
      id: map['id'] as String,
      title: map['title'] as String,
      explanation: map['explanation'] as String,
      rules: map['rules'] != null
          ? (map['rules'] as String).split('|||')
          : [],
      exampleSentences: map['example_sentences'] != null
          ? (map['example_sentences'] as String).split('|||')
          : [],
      category: map['category'] as String?,
      level: map['level'] as String?,
      isDefault: (map['is_default'] as int) == 1,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }
}
