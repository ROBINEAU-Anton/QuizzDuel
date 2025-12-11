import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../utils/constants.dart';

/// Service for fetching trivia questions from Open Trivia DB
class TriviaApiService {
  /// Fetch questions from the API
  ///
  /// [amount] - Number of questions to fetch
  /// [category] - Category ID (optional)
  /// [difficulty] - Difficulty level: easy, medium, hard (optional)
  Future<List<Question>> fetchQuestions({
    int amount = 10,
    int? category,
    String? difficulty,
    String? customCategoryId,
  }) async {
    if (customCategoryId != null) {
      return _fetchCustomQuestions(customCategoryId, amount);
    }

    try {
      // Build URL with parameters
      final queryParams = {
        'amount': amount.toString(),
        'type': 'multiple', // Multiple choice questions only
        if (category != null) 'category': category.toString(),
        if (difficulty != null) 'difficulty': difficulty,
      };

      final uri = Uri.parse(
        GameConstants.triviaApiBaseUrl,
      ).replace(queryParameters: queryParams);

      // Make API request
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check response code from API
        if (data['response_code'] == 0) {
          final results = data['results'] as List;
          return results.map((json) => Question.fromJson(json)).toList();
        } else {
          throw Exception('API returned error code: ${data['response_code']}');
        }
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      // Return fallback questions if API fails
      return _getFallbackQuestions();
    }
  }

  Future<List<Question>> _fetchCustomQuestions(String id, int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final customCategories = prefs.getStringList('custom_categories') ?? [];

    for (var catStr in customCategories) {
      final catData = jsonDecode(catStr);
      if (catData['id'] == id) {
        final questionsList = (catData['questions'] as List)
            .map((q) => Question.fromJson(q))
            .toList();
        questionsList.shuffle();
        return questionsList.take(amount).toList();
      }
    }
    return _getFallbackQuestions();
  }

  /// Fallback questions in case API is unavailable
  List<Question> _getFallbackQuestions() {
    return [
      Question(
        category: 'Science',
        difficulty: 'medium',
        question: 'Quelle est la planète la plus proche du Soleil ?',
        correctAnswer: 'Mercure',
        allAnswers: ['Mercure', 'Vénus', 'Mars', 'Terre']..shuffle(),
      ),
      Question(
        category: 'Histoire',
        difficulty: 'easy',
        question: 'En quelle année a eu lieu la Révolution française ?',
        correctAnswer: '1789',
        allAnswers: ['1789', '1776', '1804', '1815']..shuffle(),
      ),
      Question(
        category: 'Géographie',
        difficulty: 'medium',
        question: 'Quelle est la capitale de l\'Australie ?',
        correctAnswer: 'Canberra',
        allAnswers: ['Canberra', 'Sydney', 'Melbourne', 'Brisbane']..shuffle(),
      ),
      Question(
        category: 'Sport',
        difficulty: 'easy',
        question: 'Combien de joueurs composent une équipe de football ?',
        correctAnswer: '11',
        allAnswers: ['11', '10', '12', '9']..shuffle(),
      ),
      Question(
        category: 'Science',
        difficulty: 'hard',
        question: 'Quel est le symbole chimique de l\'or ?',
        correctAnswer: 'Au',
        allAnswers: ['Au', 'Ag', 'Fe', 'Cu']..shuffle(),
      ),
      Question(
        category: 'Culture',
        difficulty: 'medium',
        question: 'Qui a peint la Joconde ?',
        correctAnswer: 'Léonard de Vinci',
        allAnswers: ['Léonard de Vinci', 'Michel-Ange', 'Raphaël', 'Donatello']
          ..shuffle(),
      ),
      Question(
        category: 'Histoire',
        difficulty: 'medium',
        question: 'Quel était le premier président des États-Unis ?',
        correctAnswer: 'George Washington',
        allAnswers: [
          'George Washington',
          'Thomas Jefferson',
          'John Adams',
          'Benjamin Franklin',
        ]..shuffle(),
      ),
      Question(
        category: 'Science',
        difficulty: 'easy',
        question: 'Combien de continents y a-t-il sur Terre ?',
        correctAnswer: '7',
        allAnswers: ['7', '5', '6', '8']..shuffle(),
      ),
      Question(
        category: 'Musique',
        difficulty: 'medium',
        question: 'Quel groupe a chanté "Bohemian Rhapsody" ?',
        correctAnswer: 'Queen',
        allAnswers: ['Queen', 'The Beatles', 'Led Zeppelin', 'Pink Floyd']
          ..shuffle(),
      ),
      Question(
        category: 'Cinéma',
        difficulty: 'easy',
        question: 'Quel film a remporté l\'Oscar du meilleur film en 1994 ?',
        correctAnswer: 'Forrest Gump',
        allAnswers: [
          'Forrest Gump',
          'Pulp Fiction',
          'The Shawshank Redemption',
          'The Lion King',
        ]..shuffle(),
      ),
    ];
  }
}
