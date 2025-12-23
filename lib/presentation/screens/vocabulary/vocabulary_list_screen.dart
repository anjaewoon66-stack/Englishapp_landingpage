import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/vocabulary/vocabulary_item.dart';
import '../../providers/vocabulary_provider.dart';
import 'flashcard_screen.dart';
import 'add_edit_vocabulary_screen.dart';

class VocabularyListScreen extends ConsumerStatefulWidget {
  const VocabularyListScreen({super.key});

  @override
  ConsumerState<VocabularyListScreen> createState() => _VocabularyListScreenState();
}

class _VocabularyListScreenState extends ConsumerState<VocabularyListScreen> {
  String _filterType = 'all'; // all, memorized, notMemorized

  @override
  Widget build(BuildContext context) {
    final vocabularyAsync = ref.watch(vocabularyListProvider);
    final stats = ref.watch(vocabularyStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 학습'),
        actions: [
          IconButton(
            icon: const Icon(Icons.style),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FlashcardScreen(),
                ),
              );
            },
            tooltip: '플래시카드',
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.vocabularyCard, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('전체', stats['total']!, Icons.book),
                _buildStatItem('암기', stats['memorized']!, Icons.check_circle),
                _buildStatItem('미암기', stats['notMemorized']!, Icons.circle_outlined),
              ],
            ),
          ),

          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('전체', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('암기함', 'memorized'),
                const SizedBox(width: 8),
                _buildFilterChip('미암기', 'notMemorized'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Vocabulary List
          Expanded(
            child: vocabularyAsync.when(
              data: (vocabularyList) {
                // Filter list based on selected filter
                List<VocabularyItem> filteredList = vocabularyList;
                if (_filterType == 'memorized') {
                  filteredList = vocabularyList.where((v) => v.isMemorized).toList();
                } else if (_filterType == 'notMemorized') {
                  filteredList = vocabularyList.where((v) => !v.isMemorized).toList();
                }

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_outlined, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          '단어가 없습니다',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '아래 + 버튼을 눌러 단어를 추가하세요',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final vocab = filteredList[index];
                    return _buildVocabularyItem(vocab);
                  },
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(vocabularyListProvider.notifier).loadVocabulary();
                      },
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditVocabularyScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String filterType) {
    final isSelected = _filterType == filterType;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterType = filterType;
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildVocabularyItem(VocabularyItem vocab) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (!vocab.isDefault)
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditVocabularyScreen(vocabulary: vocab),
                  ),
                );
              },
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: '편집',
            ),
          if (!vocab.isDefault)
            SlidableAction(
              onPressed: (context) {
                _showDeleteDialog(vocab);
              },
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '삭제',
            ),
        ],
      ),
      child: Card(
        child: InkWell(
          onTap: () => _showVocabularyDetail(vocab),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Memorized Checkbox
                Checkbox(
                  value: vocab.isMemorized,
                  onChanged: (value) {
                    ref.read(vocabularyListProvider.notifier).toggleMemorized(
                          vocab.id,
                          value ?? false,
                        );
                  },
                  activeColor: AppColors.success,
                ),
                const SizedBox(width: 12),

                // Vocabulary Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            vocab.word,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (vocab.pronunciation != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              vocab.pronunciation!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vocab.meaning,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (vocab.partOfSpeech != null) ...[
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(
                            vocab.partOfSpeech!,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ],
                  ),
                ),

                // Category Badge
                if (vocab.category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(vocab.category!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      vocab.category!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'beginner':
        return AppColors.success;
      case 'intermediate':
        return AppColors.warning;
      case 'advanced':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showVocabularyDetail(VocabularyItem vocab) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      vocab.word,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (vocab.pronunciation != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        vocab.pronunciation!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      vocab.meaning,
                      style: const TextStyle(fontSize: 20),
                    ),
                    if (vocab.exampleSentences.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        '예문',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...vocab.exampleSentences.map((sentence) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              sentence,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(VocabularyItem vocab) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('단어 삭제'),
          content: Text('\'${vocab.word}\'를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                ref.read(vocabularyListProvider.notifier).deleteVocabulary(vocab.id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }
}
