import 'package:json_annotation/json_annotation.dart';

part 'quiz_question.g.dart';

enum QuestionType {
  multipleChoice,
  shortAnswer,
}

enum QuestionSource {
  vocabulary,
  grammar,
}

@JsonSerializable()
class QuizQuestion {
  final String id;
  final QuestionType type;
  final QuestionSource source;
  final String sourceItemId;
  final String question;
  final String correctAnswer;
  final List<String>? options;

  const QuizQuestion({
    required this.id,
    required this.type,
    required this.source,
    required this.sourceItemId,
    required this.question,
    required this.correctAnswer,
    this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);
}
