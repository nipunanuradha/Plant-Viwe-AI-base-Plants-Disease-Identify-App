import 'package:flutter/material.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: "What part of the plant conducts photosynthesis?",
      options: ["Roots", "Stem", "Leaves", "Flowers"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "Which gas do plants absorb from the atmosphere?",
      options: ["Oxygen", "Nitrogen", "Carbon Dioxide", "Hydrogen"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "Which part of the plant anchors it to the ground?",
      options: ["Stem", "Leaves", "Roots", "Flower"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "What is the process by which plants lose water vapor?",
      options: ["Respiration", "Transpiration", "Condensation", "Evaporation"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "Which pigment makes plant leaves green?",
      options: ["Melanin", "Xanthophyll", "Chlorophyll", "Carotene"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "Which part of the plant is responsible for reproduction?",
      options: ["Stem", "Roots", "Leaves", "Flowers"],
      correctIndex: 3,
    ),
    QuizQuestion(
      question: "Which type of plant grows back year after year?",
      options: ["Annual", "Perennial", "Biennial", "Seasonal"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "What do you call the baby plant inside a seed?",
      options: ["Sapling", "Shoot", "Embryo", "Sprout"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "What do plants need the most to make food?",
      options: ["Sunlight", "Soil", "Wind", "Pesticides"],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: "Which part of the plant carries water from roots to leaves?",
      options: ["Phloem", "Stem", "Stomata", "Flower"],
      correctIndex: 1,
    ),
  ];

  int _currentQuestion = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _answered = false;
  bool _quizFinished = false;

  void _selectAnswer(int index) {
    if (_answered || _quizFinished) return;

    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (index == _questions[_currentQuestion].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _answered = false;
        _selectedIndex = null;
      });
    } else {
      setState(() {
        _quizFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = !_quizFinished ? _questions[_currentQuestion] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🌿 Plant Quiz"),
        backgroundColor: Colors.green.shade700,
        elevation: 2,
        automaticallyImplyLeading: false, // 🔒 Hides the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _quizFinished
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_events, size: 80, color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      "🎉 You scored $_score out of ${_questions.length}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Question ${_currentQuestion + 1}/${_questions.length}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        question!.question,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(question.options.length, (index) {
                    final isSelected = index == _selectedIndex;
                    final isCorrect = index == question.correctIndex;

                    Color? getColor() {
                      if (!_answered) return Colors.white;
                      if (isCorrect) return Colors.green.shade200;
                      if (isSelected && !isCorrect) return Colors.red.shade200;
                      return Colors.white;
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: getColor(),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? Colors.green : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        title: Text(question.options[index]),
                        onTap: () => _selectAnswer(index),
                      ),
                    );
                  }),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _answered ? _nextQuestion : null,
                    icon: const Icon(Icons.navigate_next),
                    label: Text(_currentQuestion < _questions.length - 1
                        ? "Next"
                        : "Finish"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
