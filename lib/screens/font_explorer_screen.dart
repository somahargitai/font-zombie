import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/font_model.dart';

// Custom physics for horizontal snap scrolling
class HorizontalSnapScrollPhysics extends ScrollPhysics {
  final double itemWidth;
  
  const HorizontalSnapScrollPhysics({
    required this.itemWidth,
    super.parent,
  });

  @override
  HorizontalSnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HorizontalSnapScrollPhysics(
      itemWidth: itemWidth,
      parent: buildParent(ancestor),
    );
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not moving, or scrolling slowly,
    // we should return to our snap point
    if ((velocity.abs() < tolerance.velocity) ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent)) {
      
      double snapOffset = _calculateSnapOffset(position);
      const double errorTolerance = 0.1;
      
      if ((snapOffset - position.pixels).abs() > errorTolerance) {
        return ScrollSpringSimulation(
          spring,
          position.pixels,
          snapOffset,
          velocity,
          tolerance: tolerance,
        );
      }
      return null;
    }
    
    // Otherwise, use a custom simulation with a slight dampening effect
    return BouncingScrollSimulation(
      position: position.pixels,
      velocity: velocity * 0.9, // Slightly reduce velocity for better control
      leadingExtent: position.minScrollExtent,
      trailingExtent: position.maxScrollExtent,
      spring: SpringDescription.withDampingRatio(
        mass: 0.5,
        stiffness: 100.0,
        ratio: 1.1,
      ),
    );
  }
  
  double _calculateSnapOffset(ScrollMetrics position) {
    final double targetPixels = (position.pixels / itemWidth).round() * itemWidth;
    return targetPixels.clamp(position.minScrollExtent, position.maxScrollExtent);
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.0;
}

// Custom physics for more realistic wheel scrolling with enhanced feedback
class SnapScrollPhysics extends ScrollPhysics {
  final double itemExtent;
  
  const SnapScrollPhysics({
    required this.itemExtent,
    super.parent,
  });

  @override
  SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnapScrollPhysics(
      itemExtent: itemExtent,
      parent: buildParent(ancestor),
    );
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 0.8,
    stiffness: 180.0,
    damping: 20.0,
  );

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not moving, or scrolling slowly,
    // we should return to our snap point
    if ((velocity.abs() < tolerance.velocity) ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent)) {
      
      double snapOffset = _calculateSnapOffset(position);
      
      // Define a small error tolerance for precision comparison
      const double errorTolerance = 0.1;
      
      if ((snapOffset - position.pixels).abs() > errorTolerance) {
        return ScrollSpringSimulation(
          spring,
          position.pixels,
          snapOffset,
          velocity,
          tolerance: tolerance,
        );
      }
      return null;
    }
    
    // Otherwise, use a custom simulation with reduced velocity for better control
    return super.createBallisticSimulation(position, velocity * 0.8);
  }
  
  double _calculateSnapOffset(ScrollMetrics position) {
    final double itemPixels = itemExtent;
    final double targetPixels = (position.pixels / itemPixels).round() * itemPixels;
    return targetPixels.clamp(position.minScrollExtent, position.maxScrollExtent);
  }
}

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
  FontModel? _selectedFont1;
  FontModel? _selectedFont2;
  late TabController _tabController;
  
  // Controllers for horizontal scrolling
  late ScrollController _horizontalScrollController;
  int _selectedItemIndex = 0;
  bool _isScrolling = false;
  bool _isProgrammaticScroll = false; // Flag to identify programmatic scrolls
  final double _itemWidth = 60.0; // Fixed item width for consistent calculations
  
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
              _selectedLetter = _uppercaseLetters[0];
              _selectCharacterAt(0);
              break;
            case 1:
              _selectedLetter = _lowercaseLetters[0];
              _selectCharacterAt(0);
              break;
            case 2:
              _selectedLetter = _numbers[0];
              _selectCharacterAt(0);
              break;
            case 3:
              _selectedLetter = _specialCharacters[0];
              _selectCharacterAt(0);
              break;
          }
        });
      }
    });
    
    // Initialize scroll controller
    _horizontalScrollController = ScrollController(initialScrollOffset: _itemWidth * _selectedItemIndex);
    _horizontalScrollController.addListener(_handleScroll);
  }
  
  // Method to select a character at a specific index and scroll to it
  void _selectCharacterAt(int index) {
    final characters = _getCurrentCharacterSet();
    if (index >= 0 && index < characters.length) {
      setState(() {
        _selectedItemIndex = index;
        _selectedLetter = characters[index];
      });
      
      // Wait for UI to update before scrolling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedItem();
      });
    }
  }
  
  // Method to scroll to the selected item
  void _scrollToSelectedItem() {
    if (_horizontalScrollController.hasClients) {
      // Set flag to prevent handleScroll from updating selection during programmatic scroll
      _isProgrammaticScroll = true;
      
      _horizontalScrollController.animateTo(
        _itemWidth * _selectedItemIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ).then((_) {
        // Reset flag after scroll completes
        _isProgrammaticScroll = false;
      });
    }
  }
  
  // Method to handle scroll events and snap to items
  void _handleScroll() {
    if (_horizontalScrollController.hasClients && !_isProgrammaticScroll) {
      // Update the scrolling state for UI feedback
      setState(() {
        _isScrolling = _horizontalScrollController.position.isScrollingNotifier.value;
      });
      
      // Calculate the current centered item based on scroll position
      final double offset = _horizontalScrollController.offset;
      final int centerIndex = (offset / _itemWidth).round();
      
      // Update the selected letter in real-time as it comes to the center
      if (centerIndex >= 0 && 
          centerIndex < _getCurrentCharacterSet().length && 
          _selectedItemIndex != centerIndex) {
        setState(() {
          _selectedItemIndex = centerIndex;
          _selectedLetter = _getCurrentCharacterSet()[centerIndex];
        });
      }
      
      // When scroll ends, ensure it snaps precisely to the selected item
      if (!_isScrolling) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_horizontalScrollController.hasClients && !_isProgrammaticScroll) {
            _isProgrammaticScroll = true;
            _horizontalScrollController.animateTo(
              _itemWidth * _selectedItemIndex,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
            ).then((_) {
              _isProgrammaticScroll = false;
              // Add haptic feedback only when scrolling ends and snaps
              HapticFeedback.selectionClick();
            });
          }
        });
      }
    }
  }
  
  // Helper method to get the current character set based on tab
  List<String> _getCurrentCharacterSet() {
    switch (_tabController.index) {
      case 0:
        return _uppercaseLetters;
      case 1:
        return _lowercaseLetters;
      case 2:
        return _numbers;
      case 3:
        return _specialCharacters;
      default:
        return _uppercaseLetters;
    }
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
    _horizontalScrollController.removeListener(_handleScroll);
    _horizontalScrollController.dispose();
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
        // Horizontal 3D snap scroll character selector
        SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Center highlight - now vertical to indicate horizontal selection
              Positioned(
                top: 0,
                bottom: 0,
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(30),
                    border: Border(
                      left: BorderSide(color: Colors.green.withAlpha(70), width: 2),
                      right: BorderSide(color: Colors.green.withAlpha(70), width: 2),
                    ),
                  ),
                ),
              ),
              
              // Add directional indicators to show scrollability
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: _isScrolling ? 0.9 : 0.6,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.green.withAlpha(200),
                    size: 28,
                  ),
                ),
              ),
              
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: _isScrolling ? 0.9 : 0.6,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.green.withAlpha(200),
                    size: 28,
                  ),
                ),
              ),
              
              // Notification listener to detect scrolling
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // Update scrolling state for UI feedback
                  if (notification is ScrollStartNotification) {
                    setState(() {
                      _isScrolling = true;
                    });
                  } else if (notification is ScrollEndNotification) {
                    setState(() {
                      _isScrolling = false;
                    });
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: HorizontalSnapScrollPhysics(itemWidth: _itemWidth),
                  itemCount: characters.length,
                  itemExtent: _itemWidth,
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 2 - 30),
                  itemBuilder: (context, index) {
                    final char = characters[index];
                    final isSelected = index == _selectedItemIndex;
                    
                    return GestureDetector(
                      onTap: () {
                        // Set selection immediately for responsive feel
                        setState(() {
                          _selectedItemIndex = index;
                          _selectedLetter = char;
                        });
                        
                        // Use programmatic scroll flag to avoid feedback loops
                        _isProgrammaticScroll = true;
                        _horizontalScrollController.animateTo(
                          _itemWidth * index, 
                          duration: const Duration(milliseconds: 200), 
                          curve: Curves.easeOut
                        ).then((_) {
                          _isProgrammaticScroll = false;
                        });
                        
                        HapticFeedback.selectionClick();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _itemWidth,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.withAlpha(60) : Colors.black.withAlpha(40),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.green.withAlpha(100),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  )
                                ]
                              : null,
                          gradient: isSelected
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.green.withAlpha(100),
                                    Colors.green.withAlpha(40),
                                  ],
                                )
                              : null,
                          border: Border.all(
                            color: isSelected 
                                ? Colors.green.withAlpha(150)
                                : Colors.grey[800]!.withAlpha(100),
                            width: isSelected ? 1.5 : 0.5,
                          ),
                        ),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: isSelected ? 36 : 26,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.grey[500],
                              shadows: isSelected
                                  ? [
                                      Shadow(
                                        color: Colors.green.withAlpha(150),
                                        blurRadius: 2,
                                        offset: const Offset(0, 0),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Text(char),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Left gradient
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 40,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF121212),
                        const Color(0xFF121212).withAlpha(120),
                        const Color(0xFF121212).withAlpha(0),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              // Right gradient
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 40,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF121212).withAlpha(0),
                        const Color(0xFF121212).withAlpha(120),
                        const Color(0xFF121212),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              
              // Light reflection effect for added realism
              Positioned(
                left: 70,
                right: 70,
                top: 0,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.green.withAlpha(60),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ],
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
