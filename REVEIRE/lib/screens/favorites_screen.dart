import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/app_theme.dart';
import '../providers/quotes_provider.dart';
import '../widget/quote_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<QuotesProvider>().favorites;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
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
                        child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppTheme.textPrimary, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FAVORITES',
                        style: GoogleFonts.jost(
                          color: AppTheme.gold, fontSize: 11,
                          fontWeight: FontWeight.w600, letterSpacing: 4,
                        )),
                    const SizedBox(height: 4),
                    Text('Saved Quotes',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    Text(
                      '${favorites.length} ${favorites.length == 1 ? 'quote' : 'quotes'}',
                      style: GoogleFonts.jost(
                        color: AppTheme.textSecondary,
                        fontSize: 12, letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (favorites.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      const Icon(Icons.favorite_border_rounded,
                          color: AppTheme.textSecondary, size: 48),
                      const SizedBox(height: 16),
                      Text('No favorites yet',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppTheme.textSecondary)),
                      const SizedBox(height: 8),
                      Text('Tap the heart on any quote to save it',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            if (favorites.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index.isOdd) return const SizedBox(height: 16);
                      return QuoteCard(quote: favorites[index ~/ 2]);
                    },
                    childCount: favorites.length * 2 - 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}