import 'dart:math';
import 'font_model.dart';

class GameModel {
  final List<FontModel> fonts;
  late FontModel currentFont;
  late String currentLetter;
  int score = 0;
  int totalQuestions = 0;
  bool isGameOver = false;

  final List<String> alphabet = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'Aa',
    'Bb',
    'Cc',
    'Dd',
    'Ee',
    'Ff',
    'Gg',
    'Hh',
    'Ii',
    'Jj',
    'Kk',
    'Ll',
    'Mm',
    'Nn',
    'Oo',
    'Pp',
    'Qq',
    'Rr',
    'Ss',
    'Tt',
    'Uu',
    'Vv',
    'Ww',
    'Xx',
    'Yy',
    'Zz',
  ];

  GameModel({required this.fonts}) {
    resetGame();
  }

  void resetGame() {
    score = 0;
    totalQuestions = 0;
    isGameOver = false;
    selectRandomFont();
    selectRandomLetter();
  }

  void selectRandomFont() {
    final random = Random();
    currentFont = fonts[random.nextInt(fonts.length)];
  }

  void selectRandomLetter() {
    final random = Random();
    currentLetter = alphabet[random.nextInt(alphabet.length)];
  }

  bool checkAnswer(FontModel selectedFont) {
    totalQuestions++;
    final isCorrect = selectedFont.name == currentFont.name;
    if (isCorrect) {
      score++;
    }
    return isCorrect;
  }

  void nextQuestion() {
    selectRandomFont();
    selectRandomLetter();
  }

  double getScorePercentage() {
    if (totalQuestions == 0) return 0;
    return score / totalQuestions * 100;
  }
}
