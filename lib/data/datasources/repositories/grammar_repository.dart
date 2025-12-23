import 'package:sqflite/sqflite.dart';
import '../../../core/constants/app_constants.dart';
import '../local/database/app_database.dart';
import '../../models/grammar/grammar_item.dart';

class GrammarRepository {
  Future<List<GrammarItem>> getAllGrammar() async {
    final db = await AppDatabase.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.grammarTable);

    return List.generate(maps.length, (i) {
      return GrammarItem.fromMap(maps[i]);
    });
  }

  Future<List<GrammarItem>> getGrammarByCategory(String category) async {
    final db = await AppDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.grammarTable,
      where: 'category = ?',
      whereArgs: [category],
    );

    return List.generate(maps.length, (i) {
      return GrammarItem.fromMap(maps[i]);
    });
  }

  Future<GrammarItem?> getGrammarById(String id) async {
    final db = await AppDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.grammarTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return GrammarItem.fromMap(maps.first);
  }

  Future<void> insertGrammar(GrammarItem grammar) async {
    final db = await AppDatabase.database;
    await db.insert(
      AppConstants.grammarTable,
      grammar.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateGrammar(GrammarItem grammar) async {
    final db = await AppDatabase.database;
    await db.update(
      AppConstants.grammarTable,
      grammar.toMap(),
      where: 'id = ?',
      whereArgs: [grammar.id],
    );
  }

  Future<void> deleteGrammar(String id) async {
    final db = await AppDatabase.database;
    await db.delete(
      AppConstants.grammarTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getGrammarCount() async {
    final db = await AppDatabase.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.grammarTable}'),
    );
    return count ?? 0;
  }
}
