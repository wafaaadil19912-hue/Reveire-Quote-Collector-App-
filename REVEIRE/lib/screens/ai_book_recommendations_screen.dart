import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_theme.dart';
import '../services/ai_service.dart';
import '../services/firestore_service.dart';

class AIBookRecommendationsScreen extends StatefulWidget {
  const AIBookRecommendationsScreen({super.key});

  @override
  State<AIBookRecommendationsScreen> createState() =>
      _AIBookRecommendationsScreenState();
}

class _AIBookRecommendationsScreenState
    extends State<AIBookRecommendationsScreen> {
  final _controller = TextEditingController();
  List<Map<String, String>> _books = [];
  bool _loading = false;
  String _error = '';
  final _firestoreService = FirestoreService();

  final List<String> _moods = [
    'self improvement 💪',
    'sad mood 😢',
    'want to be rich 💰',
    'feeling inspired ✨',
    'need focus 🎯',
    'feeling lonely 🌙',
    'want adventure 🌍',
    'spiritual growth 🧘',
  ];

  Future<void> _search() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _loading = true;
      _error = '';
      _books = [];
    });
    try {
      final books = await AIService.getBookRecommendations(text);
      setState(() {
        _books = books;
        _loading = false;
      });
    } catch (e, stackTrace) {
      // SHOW THE FULL ERROR WITH STACK TRACE
      print('========== FULL ERROR ==========');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('================================');

      setState(() {
        _error = e.toString(); // Show the actual error
        _loading = false;
      });
    }
  }

  Future<void> _saveBook(Map<String, String> book) async {
    try {
      await _firestoreService.saveBookRecommendation(
        title: book['title']!,
        author: book['author']!,
        reason: book['reason']!,
        genre: book['genre']!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Book saved to your collection!',
              style: GoogleFonts.jost(color: AppTheme.background),
            ),
            backgroundColor: const Color(0xFF6B9E7A),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save. Please try again.',
              style: GoogleFonts.jost(color: AppTheme.background),
            ),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.textPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'BOOK RECOMMENDATIONS',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jost(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        letterSpacing: 3,
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
                    const SizedBox(height: 8),
                    Text(
                      '🎯 Book Recommendations',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us your mood or interest',
                      style: GoogleFonts.jost(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: GoogleFonts.jost(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'e.g. self improvement...',
                            ),
                            onSubmitted: (_) => _search(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _search,
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B9E7A),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_books.isEmpty && !_loading) ...[
                      Text(
                        'Try these',
                        style: GoogleFonts.jost(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _moods.map((m) {
                          return GestureDetector(
                            onTap: () {
                              _controller.text = m
                                  .replaceAll(RegExp(r'[^\x00-\x7F]'), '')
                                  .trim();
                              _search();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceElevated,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.divider),
                              ),
                              child: Text(
                                m,
                                style: GoogleFonts.jost(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 24),

                    if (_loading)
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            CircularProgressIndicator(
                              color: const Color(0xFF6B9E7A),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Finding perfect books for you...',
                              style: GoogleFonts.jost(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (_error.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        color: AppTheme.error.withAlpha(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ERROR:',
                              style: GoogleFonts.jost(
                                color: AppTheme.error,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error,
                              style: GoogleFonts.jost(
                                color: AppTheme.error,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check terminal for full details',
                              style: GoogleFonts.jost(
                                color: AppTheme.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (_books.isNotEmpty) ...[
                      Text(
                        '${_books.length} books recommended',
                        style: GoogleFonts.jost(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._books.asMap().entries.map((entry) {
                        final i = entry.key + 1;
                        final b = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border(
                                left: BorderSide(
                                  color: const Color(0xFF6B9E7A),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF6B9E7A,
                                    ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$i',
                                      style: GoogleFonts.jost(
                                        color: const Color(0xFF6B9E7A),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b['title']!,
                                        style: GoogleFonts.jost(
                                          color: AppTheme.textPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'by ${b['author']}',
                                        style: GoogleFonts.jost(
                                          color: AppTheme.gold,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        b['reason']!,
                                        style: GoogleFonts.jost(
                                          color: AppTheme.ivoryDim,
                                          fontSize: 13,
                                          height: 1.5,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF6B9E7A,
                                              ).withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              b['genre']!,
                                              style: GoogleFonts.jost(
                                                color: const Color(0xFF6B9E7A),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          // SAVE BUTTON ADDED HERE
                                          GestureDetector(
                                            onTap: () => _saveBook(b),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withValues(
                                                  alpha: 0.15,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: Colors.green
                                                      .withValues(alpha: 0.4),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.bookmark_add,
                                                    color: Colors.green,
                                                    size: 12,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'SAVE',
                                                    style: GoogleFonts.jost(
                                                      color: Colors.green,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 40),
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
