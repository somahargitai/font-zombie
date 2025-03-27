import 'package:flutter/material.dart';

class LetterWheel extends StatefulWidget {
  final List<String> letters;
  final ValueChanged<String> onLetterSelected;
  final String initialLetter;

  const LetterWheel({
    super.key,
    required this.letters,
    required this.onLetterSelected,
    required this.initialLetter,
  });

  @override
  State<LetterWheel> createState() => _LetterWheelState();
}

class _LetterWheelState extends State<LetterWheel> {
  late FixedExtentScrollController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.letters.indexOf(widget.initialLetter);
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LetterWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialLetter != widget.initialLetter) {
      final newIndex = widget.letters.indexOf(widget.initialLetter);
      if (newIndex != _selectedIndex) {
        _selectedIndex = newIndex;
        Future.microtask(() {
          _controller.animateToItem(
            _selectedIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: ListWheelScrollView.useDelegate(
          controller: _controller,
          itemExtent: 60,
          physics: const FixedExtentScrollPhysics(),
          perspective: 0.003,
          diameterRatio: 1.5,
          onSelectedItemChanged: (index) {
            setState(() {
              _selectedIndex = index;
              widget.onLetterSelected(widget.letters[index]);
            });
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.letters.length,
            builder: (context, index) {
              final isSelected = index == _selectedIndex;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green.withAlpha(77) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.letters[index][0],
                        style: TextStyle(
                          fontSize: isSelected ? 32 : 24,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      Text(
                        widget.letters[index].substring(1),
                        style: TextStyle(
                          fontSize: isSelected ? 32 : 24,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
} 