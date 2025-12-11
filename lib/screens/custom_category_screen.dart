import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';

class CustomCategoryScreen extends StatefulWidget {
  const CustomCategoryScreen({super.key});

  @override
  State<CustomCategoryScreen> createState() => _CustomCategoryScreenState();
}

class _CustomCategoryScreenState extends State<CustomCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  final List<Question> _addedQuestions = [];

  // Current Question Form Data
  final _questionController = TextEditingController();
  final _correctAnswerController = TextEditingController();
  final _wrongAnswer1Controller = TextEditingController();
  final _wrongAnswer2Controller = TextEditingController();
  final _wrongAnswer3Controller = TextEditingController();

  void _addQuestion() {
    if (_questionController.text.isEmpty ||
        _correctAnswerController.text.isEmpty ||
        _wrongAnswer1Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill at least Question, Correct Answer and 1 Wrong Answer',
          ),
        ),
      );
      return;
    }

    final incorrects = [
      _wrongAnswer1Controller.text,
      if (_wrongAnswer2Controller.text.isNotEmpty) _wrongAnswer2Controller.text,
      if (_wrongAnswer3Controller.text.isNotEmpty) _wrongAnswer3Controller.text,
    ];

    final allAnswers = [_correctAnswerController.text, ...incorrects]
      ..shuffle();

    final newQuestion = Question(
      category: _categoryNameController.text,
      difficulty: 'medium', // Default
      question: _questionController.text,
      correctAnswer: _correctAnswerController.text,
      allAnswers: allAnswers,
    );

    setState(() {
      _addedQuestions.add(newQuestion);
      _clearQuestionInputs();
    });
  }

  void _clearQuestionInputs() {
    _questionController.clear();
    _correctAnswerController.clear();
    _wrongAnswer1Controller.clear();
    _wrongAnswer2Controller.clear();
    _wrongAnswer3Controller.clear();
  }

  Future<void> _saveCategory() async {
    if (_categoryNameController.text.isEmpty || _addedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name the category and add at least 1 question'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final customCategories = prefs.getStringList('custom_categories') ?? [];

    final categoryData = {
      'id': DateTime.now().toIso8601String(),
      'name': _categoryNameController.text,
      'questions': _addedQuestions.map((q) => q.toJson()).toList(),
    };

    customCategories.add(jsonEncode(categoryData));
    await prefs.setStringList('custom_categories', customCategories);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Quiz'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveCategory),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Text('Add Question', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question Text'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _correctAnswerController,
              decoration: const InputDecoration(
                labelText: 'Correct Answer',
                filled: true,
                fillColor: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _wrongAnswer1Controller,
              decoration: const InputDecoration(labelText: 'Wrong Answer 1'),
            ),
            TextField(
              controller: _wrongAnswer2Controller,
              decoration: const InputDecoration(
                labelText: 'Wrong Answer 2 (Optional)',
              ),
            ),
            TextField(
              controller: _wrongAnswer3Controller,
              decoration: const InputDecoration(
                labelText: 'Wrong Answer 3 (Optional)',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addQuestion,
              icon: const Icon(Icons.add),
              label: const Text('Add Question to List'),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _addedQuestions.length,
              itemBuilder: (context, index) {
                final q = _addedQuestions[index];
                return ListTile(
                  title: Text(q.question),
                  subtitle: Text('Ans: ${q.correctAnswer}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _addedQuestions.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
