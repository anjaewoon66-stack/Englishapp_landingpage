import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../models/vocabulary/vocabulary_item.dart';
import '../../../models/grammar/grammar_item.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create vocabulary table
    await db.execute('''
      CREATE TABLE ${AppConstants.vocabularyTable} (
        id TEXT PRIMARY KEY,
        word TEXT NOT NULL,
        meaning TEXT NOT NULL,
        pronunciation TEXT,
        example_sentences TEXT,
        part_of_speech TEXT,
        category TEXT,
        is_memorized INTEGER DEFAULT 0,
        is_default INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        last_reviewed_at INTEGER
      )
    ''');

    // Create grammar table
    await db.execute('''
      CREATE TABLE ${AppConstants.grammarTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        explanation TEXT NOT NULL,
        rules TEXT,
        example_sentences TEXT,
        category TEXT,
        level TEXT,
        is_default INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Create quiz results table
    await db.execute('''
      CREATE TABLE ${AppConstants.quizResultsTable} (
        id TEXT PRIMARY KEY,
        question_id TEXT NOT NULL,
        question_type TEXT NOT NULL,
        source_type TEXT NOT NULL,
        source_item_id TEXT NOT NULL,
        user_answer TEXT NOT NULL,
        correct_answer TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        answered_at INTEGER NOT NULL
      )
    ''');

    // Create study sessions table
    await db.execute('''
      CREATE TABLE ${AppConstants.studySessionsTable} (
        id TEXT PRIMARY KEY,
        start_time INTEGER NOT NULL,
        end_time INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        activity_type TEXT NOT NULL,
        items_studied INTEGER NOT NULL
      )
    ''');

    // Create wrong answers table
    await db.execute('''
      CREATE TABLE ${AppConstants.wrongAnswersTable} (
        id TEXT PRIMARY KEY,
        quiz_result_id TEXT NOT NULL,
        question_type TEXT NOT NULL,
        source_type TEXT NOT NULL,
        source_item_id TEXT NOT NULL,
        question TEXT NOT NULL,
        user_answer TEXT NOT NULL,
        correct_answer TEXT NOT NULL,
        answered_at INTEGER NOT NULL,
        reviewed INTEGER DEFAULT 0
      )
    ''');

    // Create indexes
    await db.execute(
        'CREATE INDEX idx_vocabulary_category ON ${AppConstants.vocabularyTable}(category)');
    await db.execute(
        'CREATE INDEX idx_vocabulary_memorized ON ${AppConstants.vocabularyTable}(is_memorized)');
    await db.execute(
        'CREATE INDEX idx_grammar_category ON ${AppConstants.grammarTable}(category)');
    await db.execute(
        'CREATE INDEX idx_quiz_results_date ON ${AppConstants.quizResultsTable}(answered_at)');
    await db.execute(
        'CREATE INDEX idx_study_sessions_date ON ${AppConstants.studySessionsTable}(start_time)');

    // Load default data
    await _loadDefaultData(db);
  }

  static Future<void> _loadDefaultData(Database db) async {
    // Check if default data already loaded
    final vocabCount = Sqflite.firstIntValue(
      await db.rawQuery(
          'SELECT COUNT(*) FROM ${AppConstants.vocabularyTable} WHERE is_default = 1'),
    );

    if (vocabCount != null && vocabCount > 0) {
      return; // Already loaded
    }

    try {
      // Load default vocabulary
      final vocabJson =
          await rootBundle.loadString(AppConstants.defaultVocabularyPath);
      final List<dynamic> vocabList = json.decode(vocabJson);

      for (var vocabData in vocabList) {
        final vocab = VocabularyItem.fromJson(vocabData);
        await db.insert(AppConstants.vocabularyTable, vocab.toMap());
      }

      // Load default grammar
      final grammarJson =
          await rootBundle.loadString(AppConstants.defaultGrammarPath);
      final List<dynamic> grammarList = json.decode(grammarJson);

      for (var grammarData in grammarList) {
        final grammar = GrammarItem.fromJson(grammarData);
        await db.insert(AppConstants.grammarTable, grammar.toMap());
      }
    } catch (e) {
      // If assets don't exist yet, that's okay - silently continue
      // In production, you might want to use a proper logging framework
    }
  }

  static Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
