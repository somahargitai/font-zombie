import 'package:flutter/material.dart';
import '../models/font_model.dart';

class FontWheel extends StatefulWidget {
  final List<FontModel> fonts;
  final ValueChanged<FontModel> onFontSelected;
  final FontModel? initialFont;

  const FontWheel({
    super.key,
    required this.fonts,
    required this.onFontSelected,
    this.initialFont,
  });

  @override
  State<FontWheel> createState() => _FontWheelState();
}

class _FontWheelState extends State<FontWheel> {
  late FixedExtentScrollController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialFont != null) {
      _selectedIndex = widget.fonts.indexWhere((f) => f.name == widget.initialFont!.name);
      _selectedIndex = _selectedIndex == -1 ? 0 : _selectedIndex;
    }
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fonts.isNotEmpty) {
        widget.onFontSelected(widget.fonts[_selectedIndex]);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FontWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFont != null && 
        (oldWidget.initialFont == null || 
         oldWidget.initialFont!.name != widget.initialFont!.name)) {
      final newIndex = widget.fonts.indexWhere((f) => f.name == widget.initialFont!.name);
      if (newIndex != -1 && newIndex != _selectedIndex) {
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
      height: 180,
      child: Center(
        child: ListWheelScrollView.useDelegate(
          controller: _controller,
          itemExtent: 70,
          physics: const FixedExtentScrollPhysics(),
          perspective: 0.003,
          diameterRatio: 1.5,
          onSelectedItemChanged: (index) {
            setState(() {
              _selectedIndex = index;
              widget.onFontSelected(widget.fonts[index]);
            });
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.fonts.length,
            builder: (context, index) {
              final font = widget.fonts[index];
              final isSelected = index == _selectedIndex;
              
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green.withOpacity(0.3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        font.name,
                        style: TextStyle(
                          fontSize: isSelected ? 24 : 18,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.grey[400],
                        ),
                      ),
                      if (isSelected) 
                        Text(
                          '${font.year} · ${font.designer}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
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