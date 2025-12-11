// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'QuizDuel';

  @override
  String get play => 'Jouer';

  @override
  String get soloMode => 'Mode Solo';

  @override
  String get trainingMode => 'Mode Entraînement';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get createCategory => 'Créer une catégorie';

  @override
  String get questions => 'Questions';

  @override
  String get score => 'Score';

  @override
  String get gameOver => 'Fin de partie';

  @override
  String get nextQuestion => 'Question Suivante';
}
