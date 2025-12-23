import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/vocabulary/vocabulary_item.dart';
import '../../providers/vocabulary_provider.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _showOnlyNotMemorized = false;

  @override
  Widget build(BuildContext context) {
    final vocabularyAsync = ref.watch(vocabularyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('플래시카드'),
        actions: [
          PopupMenuButton<bool>(
            initialValue: _showOnlyNotMemorized,
            onSelected: (value) {
              setState(() {
                _showOnlyNotMemorized = value;
                _currentIndex = 0;
                _showAnswer = false;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: false,
                child: Text('모든 단어'),
              ),
              const PopupMenuItem(
                value: true,
                child: Text('미암기 단어만'),
              ),
            ],
          ),
        ],
      ),
      body: vocabularyAsync.when(
        data: (vocabularyList) {
          // Filter based on selection
          final List<VocabularyItem> filteredList = _showOnlyNotMemorized
              ? vocabularyList.where((v) => !v.isMemorized).toList()
              : vocabularyList;

          if (filteredList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 80, color: AppColors.success),
                  const SizedBox(height: 16),
                  const Text(
                    '모든 단어를 암기했습니다!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('축하합니다! 🎉'),
                ],
              ),
            );
          }

          final currentVocab = filteredList[_currentIndex];

          return Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_currentIndex + 1} / ${filteredList.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    LinearProgressIndicator(
                      value: (_currentIndex + 1) / filteredList.length,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ).expand(),
                  ],
                ),
              ),

              // Flashcard
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showAnswer = !_showAnswer;
                        });
                      },
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _showAnswer
                                  ? [AppColors.success, AppColors.secondaryLight]
                                  : [AppColors.vocabularyCard, AppColors.primaryLight],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!_showAnswer) ...[
                                const Text(
                                  '단어',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentVocab.word,
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (currentVocab.pronunciation != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    currentVocab.pronunciation!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ] else ...[
                                const Text(
                                  '뜻',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentVocab.meaning,
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (currentVocab.exampleSentences.isNotEmpty) ...[
                                  const SizedBox(height: 32),
                                  const Text(
                                    '예문',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...currentVocab.exampleSentences.take(2).map((sentence) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        sentence,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }),
                                ],
                              ],
                              const Spacer(),
                              Icon(
                                _showAnswer ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white70,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _showAnswer ? '단어 보기' : '뜻 보기',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Not memorized button
                    ElevatedButton.icon(
                      onPressed: () => _handleNotMemorized(currentVocab, filteredList),
                      icon: const Icon(Icons.close),
                      label: const Text('모르겠어요'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),

                    // Memorized button
                    ElevatedButton.icon(
                      onPressed: () => _handleMemorized(currentVocab, filteredList),
                      icon: const Icon(Icons.check),
                      label: const Text('알아요'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: AppColors.error),
              const SizedBox(height: 16),
              Text('오류가 발생했습니다: $error'),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMemorized(VocabularyItem vocab, List<VocabularyItem> list) {
    if (!vocab.isMemorized) {
      ref.read(vocabularyListProvider.notifier).toggleMemorized(vocab.id, true);
    }
    _moveToNext(list);
  }

  void _handleNotMemorized(VocabularyItem vocab, List<VocabularyItem> list) {
    if (vocab.isMemorized) {
      ref.read(vocabularyListProvider.notifier).toggleMemorized(vocab.id, false);
    }
    _moveToNext(list);
  }

  void _moveToNext(List<VocabularyItem> list) {
    setState(() {
      if (_currentIndex < list.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _showAnswer = false;
    });
  }
}

extension on Widget {
  Widget expand() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: this,
      ),
    );
  }
}
