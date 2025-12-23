import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/repositories/vocabulary_repository.dart';
import '../../data/models/vocabulary/vocabulary_item.dart';

// Repository provider
final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepository();
});

// Vocabulary list provider
final vocabularyListProvider =
    StateNotifierProvider<VocabularyListNotifier, AsyncValue<List<VocabularyItem>>>(
  (ref) => VocabularyListNotifier(ref.read(vocabularyRepositoryProvider)),
);

class VocabularyListNotifier extends StateNotifier<AsyncValue<List<VocabularyItem>>> {
  final VocabularyRepository _repository;

  VocabularyListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadVocabulary();
  }

  Future<void> loadVocabulary() async {
    state = const AsyncValue.loading();
    try {
      final vocabulary = await _repository.getAllVocabulary();
      state = AsyncValue.data(vocabulary);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addVocabulary({
    required String word,
    required String meaning,
    String? pronunciation,
    List<String>? exampleSentences,
    String? partOfSpeech,
    String? category,
  }) async {
    try {
      final newVocab = VocabularyItem(
        id: const Uuid().v4(),
        word: word,
        meaning: meaning,
        pronunciation: pronunciation,
        exampleSentences: exampleSentences ?? [],
        partOfSpeech: partOfSpeech,
        category: category,
        isMemorized: false,
        isDefault: false,
        createdAt: DateTime.now(),
      );

      await _repository.insertVocabulary(newVocab);
      await loadVocabulary();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateVocabulary(VocabularyItem vocabulary) async {
    try {
      await _repository.updateVocabulary(vocabulary);
      await loadVocabulary();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteVocabulary(String id) async {
    try {
      await _repository.deleteVocabulary(id);
      await loadVocabulary();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleMemorized(String id, bool isMemorized) async {
    try {
      await _repository.toggleMemorized(id, isMemorized);
      await loadVocabulary();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Filtered providers
final memorizedVocabularyProvider = Provider<List<VocabularyItem>>((ref) {
  final vocabularyAsync = ref.watch(vocabularyListProvider);
  return vocabularyAsync.whenData((items) {
    return items.where((item) => item.isMemorized).toList();
  }).value ?? [];
});

final notMemorizedVocabularyProvider = Provider<List<VocabularyItem>>((ref) {
  final vocabularyAsync = ref.watch(vocabularyListProvider);
  return vocabularyAsync.whenData((items) {
    return items.where((item) => !item.isMemorized).toList();
  }).value ?? [];
});

// Statistics providers
final vocabularyStatsProvider = Provider<Map<String, int>>((ref) {
  final vocabularyAsync = ref.watch(vocabularyListProvider);
  return vocabularyAsync.whenData((items) {
    return {
      'total': items.length,
      'memorized': items.where((item) => item.isMemorized).length,
      'notMemorized': items.where((item) => !item.isMemorized).length,
    };
  }).value ?? {'total': 0, 'memorized': 0, 'notMemorized': 0};
});
