class AppConstants {
  // Database
  static const String dbName = 'english_learning.db';
  static const int dbVersion = 1;

  // Table names
  static const String vocabularyTable = 'vocabulary';
  static const String grammarTable = 'grammar';
  static const String grammarPracticeTable = 'grammar_practice';
  static const String quizResultsTable = 'quiz_results';
  static const String studySessionsTable = 'study_sessions';
  static const String wrongAnswersTable = 'wrong_answers';

  // Asset paths
  static const String defaultVocabularyPath = 'assets/data/default_vocabulary.json';
  static const String defaultGrammarPath = 'assets/data/default_grammar.json';

  // Quiz settings
  static const List<int> quizCountOptions = [5, 10, 20];

  // Categories
  static const List<String> vocabularyCategories = [
    'beginner',
    'intermediate',
    'advanced',
  ];

  static const List<String> grammarCategories = [
    'tense',
    'conditional',
    'passive',
    'modal',
    'other',
  ];

  // Part of speech
  static const List<String> partsOfSpeech = [
    'noun',
    'verb',
    'adjective',
    'adverb',
    'preposition',
    'conjunction',
    'interjection',
  ];
}
