import 'package:html_unescape/html_unescape.dart';

/// Represents a trivia question
class Question {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> allAnswers;

  Question({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.allAnswers,
  });

  /// Create a Question from Open Trivia DB API response
  factory Question.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    // Decode HTML entities
    final decodedQuestion = unescape.convert(json['question'] as String);
    final decodedCorrectAnswer = unescape.convert(
      json['correct_answer'] as String,
    );
    final decodedIncorrectAnswers = (json['incorrect_answers'] as List)
        .map((answer) => unescape.convert(answer as String))
        .toList();

    // Combine and shuffle answers
    final allAnswers = [decodedCorrectAnswer, ...decodedIncorrectAnswers];
    allAnswers.shuffle();

    return Question(
      category: unescape.convert(json['category'] as String),
      difficulty: json['difficulty'] as String,
      question: decodedQuestion,
      correctAnswer: decodedCorrectAnswer,
      allAnswers: allAnswers,
    );
  }

  /// Check if the given answer is correct
  bool isCorrect(String answer) {
    return answer == correctAnswer;
  }

  /// Get the index of the correct answer
  int get correctAnswerIndex {
    return allAnswers.indexOf(correctAnswer);
  }
}
