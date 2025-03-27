import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/font_data.dart';
import 'models/font_model.dart';
import 'models/game_model.dart';
import 'screens/start_screen.dart';
import 'screens/game_screen.dart';
import 'screens/result_screen.dart';
import 'screens/font_explorer_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Preload Google Fonts to ensure they work on all platforms
  await GoogleFonts.pendingFonts();
  
  runApp(const FontZombieApp());
}

class FontZombieApp extends StatelessWidget {
  const FontZombieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Font Zombie',
      theme: AppTheme.darkTheme(),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum AppScreen { start, game, result, explorer }

class _MainScreenState extends State<MainScreen> {
  AppScreen _currentScreen = AppScreen.start;
  late final List<FontModel> _fonts;
  late final GameModel _gameModel;
  
  bool _isCorrect = false;
  FontModel? _selectedFont;
  FontModel? _correctFont;

  @override
  void initState() {
    super.initState();
    _fonts = FontData.getHistoricalFonts();
    _gameModel = GameModel(fonts: _fonts);
  }

  void _startGame() {
    setState(() {
      _gameModel.resetGame();
      _currentScreen = AppScreen.game;
    });
  }
  
  void _openFontExplorer() {
    setState(() {
      _currentScreen = AppScreen.explorer;
    });
  }

  void _backToHome() {
    setState(() {
      _currentScreen = AppScreen.start;
    });
  }

  void _handleSubmitAnswer(bool isCorrect, FontModel selectedFont, FontModel correctFont) {
    setState(() {
      _isCorrect = isCorrect;
      _selectedFont = selectedFont;
      _correctFont = correctFont;
      _currentScreen = AppScreen.result;
    });
  }

  void _nextQuestion() {
    setState(() {
      _gameModel.nextQuestion();
      _currentScreen = AppScreen.game;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case AppScreen.start:
        return StartScreen(
          fonts: _fonts,
          onStartGame: _startGame,
          onOpenFontExplorer: _openFontExplorer,
        );
      case AppScreen.game:
        return GameScreen(
          gameModel: _gameModel,
          onBackToHome: _backToHome,
          onSubmitAnswer: _handleSubmitAnswer,
        );
      case AppScreen.result:
        return ResultScreen(
          isCorrect: _isCorrect,
          selectedFont: _selectedFont!,
          correctFont: _correctFont!,
          onBackToHome: _backToHome,
          onNextQuestion: _nextQuestion,
        );
      case AppScreen.explorer:
        return FontExplorerScreen(
          fonts: _fonts,
          onBackToHome: _backToHome,
        );
    }
  }
}
