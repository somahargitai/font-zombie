import 'package:flutter/material.dart';
import '../models/font_model.dart';

class StartScreen extends StatelessWidget {
  final List<FontModel> fonts;
  final VoidCallback onStartGame;

  const StartScreen({
    super.key,
    required this.fonts,
    required this.onStartGame,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'FONT ZOMBIE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.green,
                ),
              ),
            ),
            
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                'Can you identify these iconic typefaces?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            
            // Game description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                'Test your typography knowledge with this font identification game featuring ${fonts.length} historically significant typefaces.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            
            const SizedBox(height: 80),
            
            // Start Game Button
            ElevatedButton(
              onPressed: onStartGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text('START GAME'),
            ),
            
            const SizedBox(height: 20),
            
            // Font count
            Text(
              '${fonts.length} iconic fonts to identify',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 