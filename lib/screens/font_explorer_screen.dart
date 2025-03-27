import 'package:flutter/material.dart';
import '../models/font_model.dart';

class FontExplorerScreen extends StatefulWidget {
  final List<FontModel> fonts;
  final VoidCallback onBackToHome;

  const FontExplorerScreen({
    super.key,
    required this.fonts,
    required this.onBackToHome,
  });

  @override
  State<FontExplorerScreen> createState() => _FontExplorerScreenState();
}

class _FontExplorerScreenState extends State<FontExplorerScreen>
    with SingleTickerProviderStateMixin {
  String _selectedLetter = 'A';
  bool _showUppercase = true;
  FontModel? _selectedFont1;
  FontModel? _selectedFont2;
  late TabController _tabController;

  // Character sets
  final List<String> _uppercaseLetters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  final List<String> _lowercaseLetters = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];

  final List<String> _numbers = [
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
  ];

  final List<String> _specialCharacters = [
    '!',
    '@',
    '#',
    '\$',
    '%',
    '&',
    '*',
    '(',
    ')',
    '-',
    '+',
    '=',
    '[',
    ']',
    '{',
    '}',
    ':',
    ';',
    '"',
    '\'',
    ',',
    '.',
    '/',
    '?',
    '<',
    '>',
    '|',
    '\\',
    '~',
    '`',
  ];

  @override
  void initState() {
    super.initState();
    // Set initial fonts
    if (widget.fonts.isNotEmpty) {
      _selectedFont1 = widget.fonts[0];
      _selectedFont2 =
          widget.fonts.length > 1 ? widget.fonts[1] : widget.fonts[0];
    }

    // Initialize tab controller
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      // If tab changes, update the selected character to the first in that category
      if (_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _selectedLetter = _showUppercase ? 'A' : 'a';
              break;
            case 1:
              _selectedLetter = _showUppercase ? 'A' : 'a';
              _showUppercase = !_showUppercase;
              break;
            case 2:
              _selectedLetter = '0';
              break;
            case 3:
              _selectedLetter = '!';
              break;
          }
        });
      }
    });
  }

  // Add the missing method to calculate baseline offset
  double getBaselineOffset(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Get the distance from the top of the text to the alphabetic baseline
    return textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openFontSelector(bool isFirstFont) async {
    final result = await showModalBottomSheet<FontModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildFontSelectorModal(isFirstFont),
    );

    if (result != null) {
      setState(() {
        if (isFirstFont) {
          _selectedFont1 = result;
        } else {
          _selectedFont2 = result;
        }
      });
    }
  }

  Widget _buildFontSelectorModal(bool isFirstFont) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Text(
                      isFirstFont ? 'Select First Font' : 'Select Second Font',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.fonts.length,
                  itemBuilder: (context, index) {
                    final font = widget.fonts[index];
                    final bool isSelected =
                        isFirstFont
                            ? _selectedFont1?.name == font.name
                            : _selectedFont2?.name == font.name;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color:
                          isSelected
                              ? (isFirstFont
                                  ? Colors.blue.withAlpha(40)
                                  : Colors.purple.withAlpha(40))
                              : const Color(0xFF242424),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? (isFirstFont ? Colors.blue : Colors.purple)
                                  : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.pop(context, font),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    font.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isSelected
                                              ? (isFirstFont
                                                  ? Colors.blue[300]
                                                  : Colors.purple[300])
                                              : Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${font.year}',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                font.designer,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'AaBbCc123',
                                style: TextStyle(
                                  fontFamily: font.fontFamily,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children:
                                    font.tags
                                        .map(
                                          (tag) => Chip(
                                            label: Text(
                                              tag,
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                            backgroundColor: const Color(
                                              0xFF333333,
                                            ),
                                            padding: EdgeInsets.zero,
                                            labelPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                ),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCharacterSelector() {
    // Determine which character set to show based on the tab
    List<String> characters;
    switch (_tabController.index) {
      case 0:
        characters = _uppercaseLetters;
        break;
      case 1:
        characters = _lowercaseLetters;
        break;
      case 2:
        characters = _numbers;
        break;
      case 3:
        characters = _specialCharacters;
        break;
      default:
        characters = _uppercaseLetters;
    }

    return Column(
      children: [
        // Tab bar for character types
        TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey[400],
          indicatorColor: Colors.green,
          tabs: const [
            Tab(text: 'ABC'),
            Tab(text: 'abc'),
            Tab(text: '123'),
            Tab(text: '#@!'),
          ],
        ),
        const SizedBox(height: 15),
        // Character selector
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final char = characters[index];
              final isSelected = char == _selectedLetter;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLetter = char;
                  });
                },
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.green.withAlpha(77)
                            : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey[700]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      char,
                      style: TextStyle(
                        fontSize: isSelected ? 32 : 24,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Explorer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackToHome,
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFF121212)),
        child: Column(
          children: [
            // Character selector
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Select a Character',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _buildCharacterSelector(),

            // Display area for the selected letter in both fonts
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Row(
                  children: [
                    if (_selectedFont1 != null)
                      Expanded(
                        child: _buildFontDisplay(_selectedFont1!, isLeft: true),
                      ),
                    const SizedBox(width: 20),
                    if (_selectedFont2 != null)
                      Expanded(
                        child: _buildFontDisplay(
                          _selectedFont2!,
                          isLeft: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Font selector buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border(
                  top: BorderSide(color: Colors.grey[800]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openFontSelector(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withAlpha(40),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.blue.withAlpha(100)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('FIRST FONT'),
                          if (_selectedFont1 != null)
                            Text(
                              _selectedFont1!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openFontSelector(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.withAlpha(40),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.purple.withAlpha(100)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('SECOND FONT'),
                          if (_selectedFont2 != null)
                            Text(
                              _selectedFont2!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontDisplay(FontModel font, {required bool isLeft}) {
    // Create a container with the same layout as before
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isLeft
                  ? Colors.blue.withAlpha(100)
                  : Colors.purple.withAlpha(100),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Font info section with fixed height
          Container(
            height: 70, // Fixed height for the header
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  font.name,
                  style: TextStyle(
                    color: isLeft ? Colors.blue[300] : Colors.purple[300],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  font.designer,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${font.year}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Divider(height: 10),

          // Character display with maximum size
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate optimal font size based on available width
                // We prioritize width over height for characters
                double fontSize = constraints.maxWidth;
                
                // For wide characters like 'W', we reduce the size slightly
                bool isWideCharacter = _selectedLetter.contains(RegExp(r'[WMwm@%]'));
                double sizeFactor = isWideCharacter ? 0.85 : 1.1;
                
                return Center(
                  child: Text(
                    _selectedLetter,
                    style: TextStyle(
                      fontFamily: font.fontFamily,
                      fontSize: fontSize * sizeFactor,
                      color: Colors.white,
                      height: 0.9, // Reduce line height to fit better
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
