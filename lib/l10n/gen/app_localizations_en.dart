// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'QuizDuel';

  @override
  String get play => 'Play';

  @override
  String get soloMode => 'Solo Mode';

  @override
  String get trainingMode => 'Training Mode';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get createCategory => 'Create Category';

  @override
  String get questions => 'Questions';

  @override
  String get score => 'Score';

  @override
  String get gameOver => 'Game Over';

  @override
  String get nextQuestion => 'Next Question';
}
