// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => QuizQuestion(
      id: json['id'] as String,
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      source: $enumDecode(_$QuestionSourceEnumMap, json['source']),
      sourceItemId: json['sourceItemId'] as String,
      question: json['question'] as String,
      correctAnswer: json['correctAnswer'] as String,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'source': _$QuestionSourceEnumMap[instance.source]!,
      'sourceItemId': instance.sourceItemId,
      'question': instance.question,
      'correctAnswer': instance.correctAnswer,
      'options': instance.options,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'multipleChoice',
  QuestionType.shortAnswer: 'shortAnswer',
};

const _$QuestionSourceEnumMap = {
  QuestionSource.vocabulary: 'vocabulary',
  QuestionSource.grammar: 'grammar',
};
