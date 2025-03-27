import 'package:flutter/material.dart';
import '../models/font_model.dart';

class ResultScreen extends StatelessWidget {
  final bool isCorrect;
  final FontModel selectedFont;
  final FontModel correctFont;
  final VoidCallback onBackToHome;
  final VoidCallback onNextQuestion;

  const ResultScreen({
    super.key,
    required this.isCorrect,
    required this.selectedFont,
    required this.correctFont,
    required this.onBackToHome,
    required this.onNextQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCorrect ? 'Correct!' : 'Incorrect'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
        ),
        child: Column(
          children: [
            // Result status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                border: Border(
                  bottom: BorderSide(
                    color: isCorrect ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
                    size: 80,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            // Font comparison
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Font info
                      Text(
                        isCorrect 
                            ? 'You correctly identified:'
                            : 'The correct answer was:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      
                      // Correct font card
                      _buildFontCard(context, correctFont, isCorrect ? Colors.green : Colors.red),
                      
                      const SizedBox(height: 20),
                      
                      // Show selected font if incorrect
                      if (!isCorrect) ...[
                        Text(
                          'You selected:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        _buildFontCard(context, selectedFont, Colors.grey),
                      ],
                      
                      // Font description
                      const SizedBox(height: 30),
                      Text(
                        'About ${correctFont.name}:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        correctFont.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Designed in ${correctFont.year} by ${correctFont.designer}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Button row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border(
                  top: BorderSide(color: Colors.grey[800]!, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: onBackToHome,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[600]!, width: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('HOME'),
                  ),
                  ElevatedButton(
                    onPressed: onNextQuestion,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: const Text('NEXT QUESTION'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontCard(BuildContext context, FontModel font, Color accentColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accentColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  font.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: accentColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${font.year}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Designer: ${font.designer}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                style: TextStyle(
                  fontFamily: font.fontFamily,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'abcdefghijklmnopqrstuvwxyz',
                style: TextStyle(
                  fontFamily: font.fontFamily,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '1234567890!@#\$%^&*()',
                style: TextStyle(
                  fontFamily: font.fontFamily,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 