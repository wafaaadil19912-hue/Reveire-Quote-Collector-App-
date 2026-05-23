import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/app_theme.dart';
import '../models/quote.dart';
import '../providers/quotes_provider.dart';
import '../screens/quote_detail_screen.dart';

class QuoteCard extends StatefulWidget {
  final Quote quote;
  const QuoteCard({super.key, required this.quote});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.8, upperBound: 1.0, value: 1.0,
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _onFavTap() async {
    await _heartController.reverse();
    if (mounted) {
      context.read<QuotesProvider>().toggleFavorite(widget.quote.id);
      _heartController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = AppCategories.getColor(widget.quote.category);
    final emoji = AppCategories.getEmoji(widget.quote.category);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                QuoteDetailScreen(quote: widget.quote),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border(left: BorderSide(color: catColor, width: 3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  Text(widget.quote.category.toUpperCase(),
                      style: GoogleFonts.jost(
                        color: catColor, fontSize: 10,
                        fontWeight: FontWeight.w600, letterSpacing: 1.5,
                      )),
                  const Spacer(),
                  ScaleTransition(
                    scale: _heartController,
                    child: GestureDetector(
                      onTap: _onFavTap,
                      child: Icon(
                        widget.quote.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: widget.quote.isFavorite
                            ? AppTheme.gold : AppTheme.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                '"${widget.quote.text}"',
                style: GoogleFonts.cormorantGaramond(
                  color: AppTheme.textPrimary, fontSize: 18,
                  fontWeight: FontWeight.w400, height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 4, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 20, height: 1,
                    color: AppTheme.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(widget.quote.author,
                        style: GoogleFonts.jost(
                          color: AppTheme.textSecondary,
                          fontSize: 12, fontWeight: FontWeight.w400,
                        )),
                  ),
                ],
              ),
              if (widget.quote.bookName.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(width: 28),
                    Text('📖 ${widget.quote.bookName}',
                        style: GoogleFonts.jost(
                          color: AppTheme.gold.withValues(alpha: 0.7),
                          fontSize: 11, fontStyle: FontStyle.italic,
                        )),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}