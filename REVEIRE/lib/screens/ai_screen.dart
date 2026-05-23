import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_theme.dart';
import 'ai_situation_quotes_screen.dart';
import 'ai_book_overview_screen.dart';
import 'ai_book_recommendations_screen.dart';

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
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
                ],
              ),
              const SizedBox(height: 24),
              Text('AI',
                  style: GoogleFonts.jost(
                    color: AppTheme.gold, fontSize: 11,
                    fontWeight: FontWeight.w600, letterSpacing: 4,
                  )),
              const SizedBox(height: 4),
              Text('AI Features',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),


              // Feature cards
              _FeatureCard(
                emoji: '✨',
                title: 'Situation Quotes',
                subtitle:
                'Type what you\'re feeling and get relevant quotes',
                examples: [
                  'feeling heartbroken',
                  'need motivation for study',
                  'lost and confused',
                ],
                color: const Color(0xFFD4A853),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                      const AISituationQuotesScreen()),
                ),
              ),

              const SizedBox(height: 16),

              _FeatureCard(
                emoji: '📚',
                title: 'Book Overview',
                subtitle:
                'Enter any book name and get a full overview',
                examples: [
                  'Atomic Habits',
                  'The Alchemist',
                  'Think and Grow Rich',
                ],
                color: const Color(0xFF5B8CC4),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AIBookOverviewScreen()),
                ),
              ),

              const SizedBox(height: 16),

              _FeatureCard(
                emoji: '🎯',
                title: 'Book Recommendations',
                subtitle: 'Get book suggestions based on mood or interest',
                examples: [
                  'self improvement',
                  'sad mood',
                  'want to be rich',
                ],
                color: const Color(0xFF6B9E7A),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                      const AIBookRecommendationsScreen()),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<String> examples;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.examples,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: GoogleFonts.jost(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: GoogleFonts.jost(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: color, size: 16),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: examples
                  .map((e) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: color.withValues(alpha: 0.3)),
                ),
                child: Text(e,
                    style: GoogleFonts.jost(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    )),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}