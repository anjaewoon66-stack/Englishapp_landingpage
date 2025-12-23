import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/vocabulary/vocabulary_item.dart';
import '../../providers/vocabulary_provider.dart';

class AddEditVocabularyScreen extends ConsumerStatefulWidget {
  final VocabularyItem? vocabulary;

  const AddEditVocabularyScreen({super.key, this.vocabulary});

  @override
  ConsumerState<AddEditVocabularyScreen> createState() =>
      _AddEditVocabularyScreenState();
}

class _AddEditVocabularyScreenState extends ConsumerState<AddEditVocabularyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _wordController;
  late TextEditingController _meaningController;
  late TextEditingController _pronunciationController;
  late TextEditingController _exampleController;

  List<String> _exampleSentences = [];
  String? _selectedPartOfSpeech;
  String? _selectedCategory;

  bool get isEditing => widget.vocabulary != null;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.vocabulary?.word);
    _meaningController = TextEditingController(text: widget.vocabulary?.meaning);
    _pronunciationController =
        TextEditingController(text: widget.vocabulary?.pronunciation);
    _exampleController = TextEditingController();

    if (widget.vocabulary != null) {
      _exampleSentences = List.from(widget.vocabulary!.exampleSentences);
      _selectedPartOfSpeech = widget.vocabulary!.partOfSpeech;
      _selectedCategory = widget.vocabulary!.category;
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _pronunciationController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '단어 편집' : '단어 추가'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Word field
            TextFormField(
              controller: _wordController,
              decoration: const InputDecoration(
                labelText: '단어 *',
                hintText: '영어 단어를 입력하세요',
                prefixIcon: Icon(Icons.text_fields),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '단어를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Meaning field
            TextFormField(
              controller: _meaningController,
              decoration: const InputDecoration(
                labelText: '뜻 *',
                hintText: '한글 뜻을 입력하세요',
                prefixIcon: Icon(Icons.translate),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '뜻을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Pronunciation field
            TextFormField(
              controller: _pronunciationController,
              decoration: const InputDecoration(
                labelText: '발음 (선택)',
                hintText: '/ˈstʌdi/',
                prefixIcon: Icon(Icons.record_voice_over),
              ),
            ),
            const SizedBox(height: 16),

            // Part of speech dropdown
            DropdownButtonFormField<String>(
              value: _selectedPartOfSpeech,
              decoration: const InputDecoration(
                labelText: '품사 (선택)',
                prefixIcon: Icon(Icons.category),
              ),
              items: AppConstants.partsOfSpeech.map((pos) {
                return DropdownMenuItem(
                  value: pos,
                  child: Text(pos),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPartOfSpeech = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Category dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: '난이도 (선택)',
                prefixIcon: Icon(Icons.bar_chart),
              ),
              items: AppConstants.vocabularyCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Example sentences section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '예문',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_exampleSentences.length}개',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Example sentence input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _exampleController,
                    decoration: const InputDecoration(
                      hintText: '예문을 입력하세요',
                      prefixIcon: Icon(Icons.format_quote),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addExampleSentence,
                  icon: const Icon(Icons.add_circle),
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Example sentences list
            if (_exampleSentences.isNotEmpty)
              ...List.generate(_exampleSentences.length, (index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(_exampleSentences[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.error),
                      onPressed: () {
                        setState(() {
                          _exampleSentences.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              }),

            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: _saveVocabulary,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isEditing ? '수정하기' : '추가하기',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addExampleSentence() {
    if (_exampleController.text.trim().isNotEmpty) {
      setState(() {
        _exampleSentences.add(_exampleController.text.trim());
        _exampleController.clear();
      });
    }
  }

  void _saveVocabulary() {
    if (_formKey.currentState!.validate()) {
      if (isEditing) {
        // Update existing vocabulary
        final updatedVocab = widget.vocabulary!.copyWith(
          word: _wordController.text.trim(),
          meaning: _meaningController.text.trim(),
          pronunciation: _pronunciationController.text.trim().isEmpty
              ? null
              : _pronunciationController.text.trim(),
          exampleSentences: _exampleSentences,
          partOfSpeech: _selectedPartOfSpeech,
          category: _selectedCategory,
        );

        ref.read(vocabularyListProvider.notifier).updateVocabulary(updatedVocab);
      } else {
        // Add new vocabulary
        ref.read(vocabularyListProvider.notifier).addVocabulary(
              word: _wordController.text.trim(),
              meaning: _meaningController.text.trim(),
              pronunciation: _pronunciationController.text.trim().isEmpty
                  ? null
                  : _pronunciationController.text.trim(),
              exampleSentences: _exampleSentences,
              partOfSpeech: _selectedPartOfSpeech,
              category: _selectedCategory,
            );
      }

      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? '단어가 수정되었습니다' : '단어가 추가되었습니다',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
