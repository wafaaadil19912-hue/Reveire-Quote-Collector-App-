import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.gold : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: isSelected ? AppTheme.gold : AppTheme.divider,
            width: 1,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.jost(
            color: isSelected
                ? AppTheme.background : AppTheme.textSecondary,
            fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}