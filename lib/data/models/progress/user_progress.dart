class UserProgress {
  final int totalVocabularyCount;
  final int memorizedVocabularyCount;
  final int totalGrammarCount;
  final int totalQuizzesTaken;
  final int totalQuestionsAnswered;
  final int totalCorrectAnswers;
  final int totalStudyMinutes;
  final DateTime? lastStudyDate;

  const UserProgress({
    required this.totalVocabularyCount,
    required this.memorizedVocabularyCount,
    required this.totalGrammarCount,
    required this.totalQuizzesTaken,
    required this.totalQuestionsAnswered,
    required this.totalCorrectAnswers,
    required this.totalStudyMinutes,
    this.lastStudyDate,
  });

  double get overallAccuracy =>
      totalQuestionsAnswered > 0
          ? (totalCorrectAnswers / totalQuestionsAnswered) * 100
          : 0.0;

  double get memorizedPercentage =>
      totalVocabularyCount > 0
          ? (memorizedVocabularyCount / totalVocabularyCount) * 100
          : 0.0;
}
