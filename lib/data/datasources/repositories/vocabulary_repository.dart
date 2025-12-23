import 'package:sqflite/sqflite.dart';
import '../../../core/constants/app_constants.dart';
import '../local/database/app_database.dart';
import '../../models/vocabulary/vocabulary_item.dart';

class VocabularyRepository {
  Future<List<VocabularyItem>> getAllVocabulary() async {
    final db = await AppDatabase.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.vocabularyTable);

    return List.generate(maps.length, (i) {
      return VocabularyItem.fromMap(maps[i]);
    });
  }

  Future<List<VocabularyItem>> getMemorizedVocabulary() async {
    final db = await AppDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vocabularyTable,
      where: 'is_memorized = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return VocabularyItem.fromMap(maps[i]);
    });
  }

  Future<List<VocabularyItem>> getVocabularyByCategory(String category) async {
    final db = await AppDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vocabularyTable,
      where: 'category = ?',
      whereArgs: [category],
    );

    return List.generate(maps.length, (i) {
      return VocabularyItem.fromMap(maps[i]);
    });
  }

  Future<VocabularyItem?> getVocabularyById(String id) async {
    final db = await AppDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vocabularyTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return VocabularyItem.fromMap(maps.first);
  }

  Future<void> insertVocabulary(VocabularyItem vocabulary) async {
    final db = await AppDatabase.database;
    await db.insert(
      AppConstants.vocabularyTable,
      vocabulary.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateVocabulary(VocabularyItem vocabulary) async {
    final db = await AppDatabase.database;
    await db.update(
      AppConstants.vocabularyTable,
      vocabulary.toMap(),
      where: 'id = ?',
      whereArgs: [vocabulary.id],
    );
  }

  Future<void> deleteVocabulary(String id) async {
    final db = await AppDatabase.database;
    await db.delete(
      AppConstants.vocabularyTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleMemorized(String id, bool isMemorized) async {
    final db = await AppDatabase.database;
    await db.update(
      AppConstants.vocabularyTable,
      {
        'is_memorized': isMemorized ? 1 : 0,
        'last_reviewed_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getVocabularyCount() async {
    final db = await AppDatabase.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.vocabularyTable}'),
    );
    return count ?? 0;
  }

  Future<int> getMemorizedCount() async {
    final db = await AppDatabase.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
          'SELECT COUNT(*) FROM ${AppConstants.vocabularyTable} WHERE is_memorized = 1'),
    );
    return count ?? 0;
  }
}
