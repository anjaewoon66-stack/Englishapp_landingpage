import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/grammar/grammar_item.dart';
import '../../providers/grammar_provider.dart';
import 'grammar_detail_screen.dart';

class GrammarListScreen extends ConsumerWidget {
  const GrammarListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grammarAsync = ref.watch(grammarListProvider);
    final stats = ref.watch(grammarStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('문법 학습'),
      ),
      body: Column(
        children: [
          // Statistics Card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.grammarCard, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('전체', stats['total']!, Icons.school),
                _buildStatItem('초급', stats['beginner']!, Icons.looks_one),
                _buildStatItem('중급', stats['intermediate']!, Icons.looks_two),
                _buildStatItem('고급', stats['advanced']!, Icons.looks_3),
              ],
            ),
          ),

          // Grammar List
          Expanded(
            child: grammarAsync.when(
              data: (grammarList) {
                if (grammarList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school_outlined, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          '문법 항목이 없습니다',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: grammarList.length,
                  itemBuilder: (context, index) {
                    final grammar = grammarList[index];
                    return _buildGrammarItem(context, grammar);
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
                        ref.read(grammarListProvider.notifier).loadGrammar();
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
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildGrammarItem(BuildContext context, GrammarItem grammar) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GrammarDetailScreen(grammar: grammar),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      grammar.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (grammar.level != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getLevelColor(grammar.level!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        grammar.level!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                grammar.explanation,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (grammar.category != null) ...[
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    grammar.category!,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppColors.grammarCard.withValues(alpha: 0.2),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
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
}
