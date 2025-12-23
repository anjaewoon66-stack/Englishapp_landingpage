import 'package:json_annotation/json_annotation.dart';

part 'quiz_result.g.dart';

@JsonSerializable()
class QuizResult {
  final String id;
  final String questionId;
  final String userAnswer;
  final bool isCorrect;
  final DateTime answeredAt;

  const QuizResult({
    required this.id,
    required this.questionId,
    required this.userAnswer,
    required this.isCorrect,
    required this.answeredAt,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) =>
      _$QuizResultFromJson(json);

  Map<String, dynamic> toJson() => _$QuizResultToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': questionId,
      'user_answer': userAnswer,
      'is_correct': isCorrect ? 1 : 0,
      'answered_at': answeredAt.millisecondsSinceEpoch,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      id: map['id'] as String,
      questionId: map['question_id'] as String,
      userAnswer: map['user_answer'] as String,
      isCorrect: (map['is_correct'] as int) == 1,
      answeredAt:
          DateTime.fromMillisecondsSinceEpoch(map['answered_at'] as int),
    );
  }
}
