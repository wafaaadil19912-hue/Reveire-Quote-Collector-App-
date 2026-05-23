import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/app_theme.dart';
import '../models/quote.dart';
import '../providers/quotes_provider.dart';
import 'add_edit_quote_screen.dart';

class QuoteDetailScreen extends StatelessWidget {
  final Quote quote;
  const QuoteDetailScreen({super.key, required this.quote});

  String _buildShareText(Quote q) {
    String text = '"${q.text}"\n\n— ${q.author}';
    if (q.bookName.isNotEmpty) text += '\n📖 ${q.bookName}';
    return text;
  }

  void _share(BuildContext context, Quote q, String platform) {
    final shareText = _buildShareText(q);
    if (platform == 'copy' || platform == 'instagram') {
      Clipboard.setData(ClipboardData(text: shareText));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          platform == 'instagram'
              ? 'Copied! Paste it on Instagram'
              : 'Copied to clipboard',
          style: GoogleFonts.jost(color: AppTheme.background),
        ),
        backgroundColor: AppTheme.gold,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ));
    } else {
      Clipboard.setData(ClipboardData(text: shareText));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Copied! Paste it on ${_platformName(platform)}',
          style: GoogleFonts.jost(color: AppTheme.background),
        ),
        backgroundColor: AppTheme.gold,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ));
    }
  }

  String _platformName(String platform) {
    switch (platform) {
      case 'whatsapp': return 'WhatsApp';
      case 'twitter': return 'Twitter';
      case 'facebook': return 'Facebook';
      default: return platform;
    }
  }

  void _showShareSheet(BuildContext context, Quote q) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share Quote',
                style: GoogleFonts.cormorantGaramond(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                )),
            const SizedBox(height: 6),
            Text(
              'Quote will be copied — paste it on the app',
              style: GoogleFonts.jost(
                  color: AppTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ShareBtn(
                  icon: '💬', label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () {
                    Navigator.pop(context);
                    _share(context, q, 'whatsapp');
                  },
                ),
                _ShareBtn(
                  icon: '📸', label: 'Instagram',
                  color: const Color(0xFFE1306C),
                  onTap: () {
                    Navigator.pop(context);
                    _share(context, q, 'instagram');
                  },
                ),
                _ShareBtn(
                  icon: '🐦', label: 'Twitter',
                  color: const Color(0xFF1DA1F2),
                  onTap: () {
                    Navigator.pop(context);
                    _share(context, q, 'twitter');
                  },
                ),
                _ShareBtn(
                  icon: '👤', label: 'Facebook',
                  color: const Color(0xFF1877F2),
                  onTap: () {
                    Navigator.pop(context);
                    _share(context, q, 'facebook');
                  },
                ),
                _ShareBtn(
                  icon: '📋', label: 'Copy',
                  color: AppTheme.gold,
                  onTap: () {
                    Navigator.pop(context);
                    _share(context, q, 'copy');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuotesProvider>();
    final updatedQuote = provider.quotes.firstWhere(
          (q) => q.id == quote.id,
      orElse: () => quote,
    );
    final catColor = AppCategories.getColor(updatedQuote.category);
    final emoji = AppCategories.getEmoji(updatedQuote.category);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _IconBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  Text('QUOTE',
                      style: GoogleFonts.jost(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        letterSpacing: 3,
                      )),
                  Row(
                    children: [
                      _IconBtn(
                        icon: Icons.edit_outlined,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditQuoteScreen(
                                existingQuote: updatedQuote),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _IconBtn(
                        icon: Icons.delete_outline_rounded,
                        onTap: () => _confirmDelete(
                            context, context.read<QuotesProvider>()),
                        color: AppTheme.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text('❝',
                        style: TextStyle(
                          fontSize: 64,
                          color: catColor.withValues(alpha: 0.4),
                          height: 0.8,
                        )),
                    const SizedBox(height: 24),

                    // Quote text
                    Text(updatedQuote.text,
                        style: GoogleFonts.cormorantGaramond(
                          color: AppTheme.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        )),

                    const SizedBox(height: 32),
                    Container(
                        width: 48,
                        height: 1,
                        color: catColor.withValues(alpha: 0.5)),
                    const SizedBox(height: 20),

                    // Author
                    Text(updatedQuote.author,
                        style: GoogleFonts.jost(
                          color: AppTheme.ivoryDim,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),

                    // Book name
                    if (updatedQuote.bookName.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(children: [
                        const Text('📖',
                            style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 6),
                        Text(updatedQuote.bookName,
                            style: GoogleFonts.jost(
                              color: AppTheme.gold,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            )),
                      ]),
                    ],

                    const SizedBox(height: 8),

                    // Category
                    Row(children: [
                      Text(emoji,
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(updatedQuote.category,
                          style: GoogleFonts.jost(
                            color: catColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          )),
                    ]),

                    const SizedBox(height: 60),

                    // Action buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ActionBtn(
                          icon: updatedQuote.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          label: updatedQuote.isFavorite
                              ? 'SAVED'
                              : 'FAVORITE',
                          color: updatedQuote.isFavorite
                              ? AppTheme.gold
                              : AppTheme.textSecondary,
                          onTap: () =>
                              provider.toggleFavorite(updatedQuote.id),
                        ),
                        _ActionBtn(
                          icon: Icons.share_rounded,
                          label: 'SHARE',
                          color: AppTheme.textSecondary,
                          onTap: () =>
                              _showShareSheet(context, updatedQuote),
                        ),
                        _ActionBtn(
                          icon: Icons.copy_rounded,
                          label: 'COPY',
                          color: AppTheme.textSecondary,
                          onTap: () =>
                              _share(context, updatedQuote, 'copy'),
                        ),
                      ],
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

  void _confirmDelete(BuildContext context, QuotesProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceElevated,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)),
        title: Text('Delete Quote',
            style: GoogleFonts.cormorantGaramond(
                color: AppTheme.textPrimary, fontSize: 22)),
        content: Text(
            'Are you sure you want to remove this quote?',
            style: GoogleFonts.jost(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL',
                style: GoogleFonts.jost(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    letterSpacing: 1)),
          ),
          TextButton(
            onPressed: () {
              provider.deleteQuote(quote.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('DELETE',
                style: GoogleFonts.jost(
                    color: AppTheme.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1)),
          ),
        ],
      ),
    );
  }
}

class _ShareBtn extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border:
              Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Center(
                child:
                Text(icon, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: GoogleFonts.jost(
                color: AppTheme.textSecondary,
                fontSize: 10,
                letterSpacing: 0.5,
              )),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _IconBtn({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon,
            color: color ?? AppTheme.textPrimary, size: 18),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.jost(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                )),
          ],
        ),
      ),
    );
  }
}