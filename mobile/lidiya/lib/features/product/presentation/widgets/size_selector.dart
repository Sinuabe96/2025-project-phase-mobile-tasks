import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SizeSelector extends StatelessWidget {
  final List<int> sizes;
  final int selected;
  final ValueChanged<int> onChanged;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: sizes.map((size) {
        final isSelected = size == selected;
        return GestureDetector(
          onTap: () => onChanged(size),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              size.toString(),
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
