# Quiz Battle 🎮

Jeu de quiz multijoueur en mode "hot seat" pour 2-4 joueurs, développé avec Flutter Web.

## 🎯 Fonctionnalités

- **Mode multijoueur local** : 2 à 4 joueurs sur le même écran
- **Zones de jeu dédiées** : Chaque joueur a sa propre zone avec boutons de réponse
- **Système de points intelligent** :
  - 100 points par bonne réponse
  - Jusqu'à 50 points bonus de rapidité
  - Maximum 150 points par question
- **Catégories variées** : Science, Histoire, Géographie, Sport, Divertissement, etc.
- **3 niveaux de difficulté** : Facile, Moyen, Difficile
- **Animations dynamiques** : Victoire avec confetti, transitions fluides
- **Classement persistant** : Top 10 des meilleurs scores sauvegardés localement

## 🚀 Installation

### Prérequis
- Flutter SDK (>= 3.10.3)
- Chrome ou un navigateur web moderne

### Étapes

```bash
# Cloner le dépôt
git clone <votre-repo-url>
cd projetQuizzIA

# Installer les dépendances
flutter pub get

# Lancer en mode développement
flutter run -d chrome

# Ou construire pour la production
flutter build web --release
```

## 🎮 Comment jouer

1. **Configuration** : Sélectionnez le nombre de joueurs (2-4) et entrez les noms
2. **Catégorie** : Choisissez une catégorie ou "Toutes les catégories"
3. **Difficulté** : Sélectionnez le niveau (Facile/Moyen/Difficile)
4. **Jeu** : Répondez aux 10 questions le plus rapidement possible
5. **Résultats** : Consultez les scores finaux et le classement

## 🏗️ Architecture

```
lib/
├── main.dart                    # Point d'entrée
├── models/                      # Modèles de données
│   ├── player.dart
│   ├── question.dart
│   └── game_state.dart
├── providers/                   # Gestion d'état
│   └── game_provider.dart
├── services/                    # Services externes
│   ├── trivia_api_service.dart
│   └── leaderboard_service.dart
├── screens/                     # Écrans de l'application
│   ├── home_screen.dart
│   ├── player_setup_screen.dart
│   ├── game_screen.dart
│   ├── results_screen.dart
│   └── leaderboard_screen.dart
├── widgets/                     # Composants réutilisables
│   ├── player_zone.dart
│   ├── question_card.dart
│   ├── timer_widget.dart
│   └── victory_animation.dart
├── theme/                       # Thème et styles
│   └── app_theme.dart
└── utils/                       # Constantes et utilitaires
    └── constants.dart
```

## 📦 Dépendances principales

- `provider` - Gestion d'état
- `http` - Appels API
- `shared_preferences` - Stockage local
- `google_fonts` - Typographie
- `html_unescape` - Décodage HTML
- `intl` - Formatage des dates

## 🌐 API

Ce projet utilise l'[Open Trivia Database API](https://opentdb.com/) pour récupérer les questions de quiz.

## 📝 Licence

Ce projet a été créé dans un cadre éducatif.

## 👨‍💻 Auteur

Développé avec Flutter Web
