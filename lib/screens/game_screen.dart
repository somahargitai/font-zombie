import 'package:flutter/material.dart';
import '../models/font_model.dart';
import '../models/game_model.dart';
import '../widgets/letter_wheel.dart';
import '../widgets/font_wheel.dart';

class GameScreen extends StatefulWidget {
  final GameModel gameModel;
  final VoidCallback onBackToHome;
  final Function(bool isCorrect, FontModel selectedFont, FontModel correctFont) onSubmitAnswer;

  const GameScreen({
    super.key,
    required this.gameModel,
    required this.onBackToHome,
    required this.onSubmitAnswer,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late String _currentLetter;
  late FontModel _currentCorrectFont;
  FontModel? _selectedFont;

  @override
  void initState() {
    super.initState();
    _currentLetter = widget.gameModel.currentLetter;
    _currentCorrectFont = widget.gameModel.currentFont;
  }

  void _onLetterChanged(String letter) {
    setState(() {
      _currentLetter = letter;
    });
  }

  void _onFontSelected(FontModel font) {
    setState(() {
      _selectedFont = font;
    });
  }

  void _submitAnswer() {
    if (_selectedFont == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a font first')),
      );
      return;
    }
    
    final isCorrect = widget.gameModel.checkAnswer(_selectedFont!);
    widget.onSubmitAnswer(isCorrect, _selectedFont!, _currentCorrectFont);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Identification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackToHome,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Score: ${widget.gameModel.score}/${widget.gameModel.totalQuestions}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Display the letter in the current font
            Expanded(
              flex: 4,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    _currentLetter,
                    style: TextStyle(
                      fontFamily: _currentCorrectFont.fontFamily,
                      fontSize: 200,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            
            // Divider
            Divider(color: Colors.grey[800], thickness: 1, height: 1),
            
            // Letter wheel section
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    'Choose a Letter',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  LetterWheel(
                    letters: widget.gameModel.alphabet,
                    onLetterSelected: _onLetterChanged,
                    initialLetter: _currentLetter,
                  ),
                ],
              ),
            ),
            
            // Divider
            Divider(color: Colors.grey[800], thickness: 1, height: 1),
            
            // Font selection wheel
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(
                      'Select the Font',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Expanded(
                      child: FontWheel(
                        fonts: widget.gameModel.fonts,
                        onFontSelected: _onFontSelected,
                      ),
                    ),
                    
             
                    
                    // Submit button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      child: ElevatedButton(
                        onPressed: _submitAnswer,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: const Text('SUBMIT'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 