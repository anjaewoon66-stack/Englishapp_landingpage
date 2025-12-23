// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizResult _$QuizResultFromJson(Map<String, dynamic> json) => QuizResult(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      userAnswer: json['userAnswer'] as String,
      isCorrect: json['isCorrect'] as bool,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );

Map<String, dynamic> _$QuizResultToJson(QuizResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'userAnswer': instance.userAnswer,
      'isCorrect': instance.isCorrect,
      'answeredAt': instance.answeredAt.toIso8601String(),
    };
