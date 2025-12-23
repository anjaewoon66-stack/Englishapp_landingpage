import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/repositories/grammar_repository.dart';
import '../../data/models/grammar/grammar_item.dart';

// Repository provider
final grammarRepositoryProvider = Provider<GrammarRepository>((ref) {
  return GrammarRepository();
});

// Grammar list provider
final grammarListProvider =
    StateNotifierProvider<GrammarListNotifier, AsyncValue<List<GrammarItem>>>(
  (ref) => GrammarListNotifier(ref.read(grammarRepositoryProvider)),
);

class GrammarListNotifier extends StateNotifier<AsyncValue<List<GrammarItem>>> {
  final GrammarRepository _repository;

  GrammarListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadGrammar();
  }

  Future<void> loadGrammar() async {
    state = const AsyncValue.loading();
    try {
      final grammar = await _repository.getAllGrammar();
      state = AsyncValue.data(grammar);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addGrammar({
    required String title,
    required String explanation,
    List<String>? rules,
    List<String>? exampleSentences,
    String? category,
    String? level,
  }) async {
    try {
      final newGrammar = GrammarItem(
        id: const Uuid().v4(),
        title: title,
        explanation: explanation,
        rules: rules ?? [],
        exampleSentences: exampleSentences ?? [],
        category: category,
        level: level,
        isDefault: false,
        createdAt: DateTime.now(),
      );

      await _repository.insertGrammar(newGrammar);
      await loadGrammar();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateGrammar(GrammarItem grammar) async {
    try {
      await _repository.updateGrammar(grammar);
      await loadGrammar();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteGrammar(String id) async {
    try {
      await _repository.deleteGrammar(id);
      await loadGrammar();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Statistics provider
final grammarStatsProvider = Provider<Map<String, int>>((ref) {
  final grammarAsync = ref.watch(grammarListProvider);
  return grammarAsync.whenData((items) {
    return {
      'total': items.length,
      'beginner': items.where((item) => item.level == 'beginner').length,
      'intermediate': items.where((item) => item.level == 'intermediate').length,
      'advanced': items.where((item) => item.level == 'advanced').length,
    };
  }).value ?? {'total': 0, 'beginner': 0, 'intermediate': 0, 'advanced': 0};
});
