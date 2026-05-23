import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/app_theme.dart';
import '../models/quote.dart';
import '../providers/quotes_provider.dart';

class AddEditQuoteScreen extends StatefulWidget {
  final Quote? existingQuote;
  const AddEditQuoteScreen({super.key, this.existingQuote});

  @override
  State<AddEditQuoteScreen> createState() => _AddEditQuoteScreenState();
}

class _AddEditQuoteScreenState extends State<AddEditQuoteScreen> {
  late TextEditingController _textController;
  late TextEditingController _authorController;
  late TextEditingController _bookNameController;
  late String _selectedCategory;

  bool get _isEditing => widget.existingQuote != null;

  @override
  void initState() {
    super.initState();
    _textController =
        TextEditingController(text: widget.existingQuote?.text ?? '');
    _authorController =
        TextEditingController(text: widget.existingQuote?.author ?? '');
    _bookNameController =
        TextEditingController(text: widget.existingQuote?.bookName ?? '');
    _selectedCategory = widget.existingQuote?.category ??
        AppCategories.categories[0]['name'] as String;
  }

  @override
  void dispose() {
    _textController.dispose();
    _authorController.dispose();
    _bookNameController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.jost(color: AppTheme.ivory)),
      backgroundColor: AppTheme.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ));
  }

  void _save() {
    final text = _textController.text.trim();
    final author = _authorController.text.trim();
    if (text.isEmpty) { _showError('Please enter the quote text'); return; }
    if (author.isEmpty) { _showError('Please enter the author name'); return; }

    final provider = context.read<QuotesProvider>();
    if (_isEditing) {
      provider.editQuote(
        widget.existingQuote!.id,
        text: text,
        author: author,
        bookName: _bookNameController.text.trim(),
        category: _selectedCategory,
      );
    } else {
      provider.addQuote(
        text: text,
        author: author,
        bookName: _bookNameController.text.trim(),
        category: _selectedCategory,
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: AppTheme.textPrimary, size: 20),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _isEditing ? 'EDIT QUOTE' : 'NEW QUOTE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jost(
                        color: AppTheme.textSecondary,
                        fontSize: 11, letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _Label('THE QUOTE'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _textController,
                      style: GoogleFonts.cormorantGaramond(
                        color: AppTheme.textPrimary, fontSize: 20,
                        fontStyle: FontStyle.italic, height: 1.6,
                      ),
                      maxLines: 6, minLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter the quote here...',
                        hintStyle: GoogleFonts.cormorantGaramond(
                          color: AppTheme.textSecondary, fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _Label('AUTHOR'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _authorController,
                      style: GoogleFonts.jost(
                          color: AppTheme.textPrimary, fontSize: 15),
                      decoration:
                      const InputDecoration(hintText: 'Who said this?'),
                    ),
                    const SizedBox(height: 28),
                    _Label('BOOK NAME (OPTIONAL)'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _bookNameController,
                      style: GoogleFonts.jost(
                          color: AppTheme.textPrimary, fontSize: 15),
                      decoration: const InputDecoration(
                          hintText: 'Which book is this from?'),
                    ),
                    const SizedBox(height: 28),
                    _Label('CATEGORY'),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10, runSpacing: 10,
                      children: AppCategories.categories.map((cat) {
                        final name = cat['name'] as String;
                        final emoji = cat['emoji'] as String;
                        final isSelected = _selectedCategory == name;
                        final color = Color(cat['color'] as int);
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = name),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withValues(alpha: 0.15)
                                  : AppTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isSelected
                                    ? color : AppTheme.divider,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(emoji,
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 6),
                                Text(name,
                                    style: GoogleFonts.jost(
                                      color: isSelected
                                          ? color : AppTheme.textSecondary,
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    )),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: _save,
                      child: Container(
                        width: double.infinity, height: 54,
                        decoration: BoxDecoration(
                          color: AppTheme.gold,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.gold.withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _isEditing ? 'SAVE CHANGES' : 'ADD TO COLLECTION',
                            style: GoogleFonts.jost(
                              color: AppTheme.background, fontSize: 13,
                              fontWeight: FontWeight.w700, letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.jost(
          color: AppTheme.textSecondary, fontSize: 10,
          fontWeight: FontWeight.w600, letterSpacing: 2.5,
        ));
  }
}