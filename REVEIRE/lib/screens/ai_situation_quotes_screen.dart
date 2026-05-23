import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/app_theme.dart';
import '../providers/quotes_provider.dart';
import '../services/ai_service.dart';

class AISituationQuotesScreen extends StatefulWidget {
  const AISituationQuotesScreen({super.key});

  @override
  State<AISituationQuotesScreen> createState() =>
      _AISituationQuotesScreenState();
}

class _AISituationQuotesScreenState
    extends State<AISituationQuotesScreen> {
  final _controller = TextEditingController();
  List<Map<String, String>> _quotes = [];
  bool _loading = false;
  String _error = '';

  final List<String> _suggestions = [
    'feeling heartbroken 💔',
    'need motivation for study 📚',
    'feeling lost and confused 🌫️',
    'want to chase my dreams ✨',
    'feeling lazy and unmotivated 😴',
    'going through hard times ⚡',
  ];

  Future<void> _search() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() { _loading = true; _error = ''; _quotes = []; });
    try {
      final quotes = await AIService.getSituationQuotes(text);
      setState(() { _quotes = quotes; _loading = false; });
    } catch (e) {
      print('❌ ERROR: $e'); // DEBUG LINE
      setState(() {
        _error = 'Something went wrong. Please try again.';
        _loading = false;
      });
    }
  }

  void _saveQuote(Map<String, String> q) {
    context.read<QuotesProvider>().addQuote(
      text: q['quote']!,
      author: q['author']!,
      bookName: q['book']!,
      category: 'Motivation',
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Quote saved to collection!',
          style: GoogleFonts.jost(color: AppTheme.background)),
      backgroundColor: AppTheme.gold,
      behavior: SnackBarBehavior.floating,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.textPrimary, size: 18),
                    ),
                  ),
                  Expanded(
                    child: Text('SITUATION QUOTES',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jost(
                          color: AppTheme.textSecondary,
                          fontSize: 11, letterSpacing: 3,
                        )),
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
                    const SizedBox(height: 8),
                    Text('✨ What are you going through?',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Type your situation and get powerful quotes',
                      style: GoogleFonts.jost(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),

                    // Search field
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: GoogleFonts.jost(
                                color: AppTheme.textPrimary, fontSize: 15),
                            decoration: const InputDecoration(
                              hintText: 'e.g. feeling heartbroken...',
                            ),
                            onSubmitted: (_) => _search(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _search,
                          child: Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              color: AppTheme.gold,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded,
                                color: AppTheme.background, size: 22),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Suggestions
                    if (_quotes.isEmpty && !_loading)
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: _suggestions.map((s) {
                          return GestureDetector(
                            onTap: () {
                              _controller.text = s
                                  .replaceAll(RegExp(r'[^\x00-\x7F]'), '')
                                  .trim();
                              _search();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceElevated,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                Border.all(color: AppTheme.divider),
                              ),
                              child: Text(s,
                                  style: GoogleFonts.jost(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  )),
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 24),

                    // Loading
                    if (_loading)
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            CircularProgressIndicator(
                                color: AppTheme.gold),
                            const SizedBox(height: 16),
                            Text('Finding quotes for you...',
                                style: GoogleFonts.jost(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                )),
                          ],
                        ),
                      ),

                    // Error
                    if (_error.isNotEmpty)
                      Center(
                        child: Text(_error,
                            style: GoogleFonts.jost(
                                color: AppTheme.error, fontSize: 13)),
                      ),

                    // Results
                    if (_quotes.isNotEmpty) ...[
                      Text(
                        '${_quotes.length} quotes found',
                        style: GoogleFonts.jost(
                          color: AppTheme.textSecondary,
                          fontSize: 12, letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._quotes.map((q) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border(
                              left: BorderSide(
                                  color: AppTheme.gold, width: 3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('"${q['quote']}"',
                                  style: GoogleFonts.cormorantGaramond(
                                    color: AppTheme.textPrimary,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  )),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                      width: 20, height: 1,
                                      color: AppTheme.textSecondary
                                          .withValues(alpha: 0.4)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(q['author']!,
                                        style: GoogleFonts.jost(
                                          color: AppTheme.textSecondary,
                                          fontSize: 12,
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () => _saveQuote(q),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.gold
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                        BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppTheme.gold
                                              .withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: Text('SAVE',
                                          style: GoogleFonts.jost(
                                            color: AppTheme.gold,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              if (q['book']!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Row(children: [
                                  const SizedBox(width: 28),
                                  Text('📖 ${q['book']}',
                                      style: GoogleFonts.jost(
                                        color: AppTheme.gold
                                            .withValues(alpha: 0.7),
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                      )),
                                ]),
                              ],
                            ],
                          ),
                        ),
                      )),
                    ],
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