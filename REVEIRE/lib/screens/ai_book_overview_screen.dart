import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_theme.dart';
import '../services/ai_service.dart';

class AIBookOverviewScreen extends StatefulWidget {
  const AIBookOverviewScreen({super.key});

  @override
  State<AIBookOverviewScreen> createState() =>
      _AIBookOverviewScreenState();
}

class _AIBookOverviewScreenState extends State<AIBookOverviewScreen> {
  final _controller = TextEditingController();
  Map<String, String>? _overview;
  bool _loading = false;
  String _error = '';

  final List<String> _popular = [
    'Atomic Habits',
    'The Alchemist',
    'Think and Grow Rich',
    'Rich Dad Poor Dad',
    'The 5AM Club',
    'Ikigai',
  ];

  Future<void> _search() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() { _loading = true; _error = ''; _overview = null; });
    try {
      final overview = await AIService.getBookOverview(text);
      setState(() { _overview = overview; _loading = false; });
    } catch (e) {
      setState(() {
        _error = 'Something went wrong. Please try again.';
        _loading = false;
      });
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
                    child: Text('BOOK OVERVIEW',
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
                    Text('📚 Book Overview',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('Enter any book name to get a full overview',
                        style: GoogleFonts.jost(
                            color: AppTheme.textSecondary, fontSize: 13)),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: GoogleFonts.jost(
                                color: AppTheme.textPrimary, fontSize: 15),
                            decoration: const InputDecoration(
                                hintText: 'e.g. Atomic Habits...'),
                            onSubmitted: (_) => _search(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _search,
                          child: Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFF5B8CC4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.search_rounded,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_overview == null && !_loading) ...[
                      Text('Popular Books',
                          style: GoogleFonts.jost(
                            color: AppTheme.textSecondary,
                            fontSize: 11, letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: _popular.map((b) {
                          return GestureDetector(
                            onTap: () {
                              _controller.text = b;
                              _search();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceElevated,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppTheme.divider),
                              ),
                              child: Text(b,
                                  style: GoogleFonts.jost(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  )),
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
                                color: const Color(0xFF5B8CC4)),
                            const SizedBox(height: 16),
                            Text('Reading the book for you...',
                                style: GoogleFonts.jost(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                )),
                          ],
                        ),
                      ),

                    if (_error.isNotEmpty)
                      Text(_error,
                          style: GoogleFonts.jost(
                              color: AppTheme.error, fontSize: 13)),

                    if (_overview != null) ...[
                      // Book title & author
                      Text(_overview!['title']!,
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 4),
                      Text('by ${_overview!['author']}',
                          style: GoogleFonts.jost(
                            color: AppTheme.gold, fontSize: 14,
                            fontStyle: FontStyle.italic,
                          )),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5B8CC4)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(_overview!['genre']!,
                                style: GoogleFonts.jost(
                                  color: const Color(0xFF5B8CC4),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          const SizedBox(width: 8),
                          Text('⭐ ${_overview!['rating']}',
                              style: GoogleFonts.jost(
                                color: AppTheme.gold, fontSize: 13,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _Section(
                        title: 'SUMMARY',
                        content: _overview!['summary']!,
                        color: const Color(0xFF5B8CC4),
                      ),
                      const SizedBox(height: 16),
                      _Section(
                        title: 'KEY LESSONS',
                        content: _overview!['key_lessons']!,
                        color: AppTheme.gold,
                      ),
                      const SizedBox(height: 16),
                      _Section(
                        title: 'WHY READ THIS',
                        content: _overview!['why_read']!,
                        color: const Color(0xFF6B9E7A),
                      ),
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

class _Section extends StatelessWidget {
  final String title;
  final String content;
  final Color color;

  const _Section({
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.jost(
                color: color, fontSize: 10,
                fontWeight: FontWeight.w700, letterSpacing: 2,
              )),
          const SizedBox(height: 10),
          Text(content,
              style: GoogleFonts.jost(
                color: AppTheme.ivoryDim, fontSize: 14,
                height: 1.6, fontWeight: FontWeight.w300,
              )),
        ],
      ),
    );
  }
}