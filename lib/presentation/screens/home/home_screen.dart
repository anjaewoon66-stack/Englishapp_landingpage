import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../vocabulary/vocabulary_list_screen.dart';
import '../grammar/grammar_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const VocabularyListScreen(),
    const GrammarListScreen(),
    const QuizTab(),
    const ProgressTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '단어',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '문법',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: '퀴즈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '진도',
          ),
        ],
      ),
    );
  }
}

// Temporary placeholder widgets
class QuizTab extends StatelessWidget {
  const QuizTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('퀴즈')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 80, color: AppColors.quizCard),
            const SizedBox(height: 16),
            const Text(
              '퀴즈 기능',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('곧 구현될 예정입니다'),
          ],
        ),
      ),
    );
  }
}

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('학습 진도')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 80, color: AppColors.progressCard),
            const SizedBox(height: 16),
            const Text(
              '진도 추적 기능',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('곧 구현될 예정입니다'),
          ],
        ),
      ),
    );
  }
}
