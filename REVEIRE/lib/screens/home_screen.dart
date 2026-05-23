import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/app_theme.dart';
import '../providers/quotes_provider.dart';
import '../widget/quote_card.dart';
import '../widget/category_chip.dart';
import 'add_edit_quote_screen.dart';
import 'favorites_screen.dart';
import 'ai_screen.dart';
import 'saved_recommendations_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _filterCategories = [
    'All',
    'Motivation',
    'Life',
    'Study',
    'Chasing Dreams',
    'Wisdom',
    'Resilience',
    'Success',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuotesProvider>();
    final quotes = provider.filteredQuotes;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REVERIE',
                          style: GoogleFonts.jost(
                            color: AppTheme.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Your Quotes',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),

                    // All Buttons Row
                    Row(
                      children: [
                        // AI Button
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AIScreen()),
                          ),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.gold.withAlpha(25),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppTheme.gold.withAlpha(77),
                              ),
                            ),
                            child: const Center(
                              child: Text('✨', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Favorites Button
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const FavoritesScreen(),
                              transitionsBuilder: (_, anim, __, child) =>
                                  SlideTransition(
                                    position:
                                        Tween<Offset>(
                                          begin: const Offset(0, 1),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: anim,
                                            curve: Curves.easeOutCubic,
                                          ),
                                        ),
                                    child: child,
                                  ),
                              transitionDuration: const Duration(
                                milliseconds: 400,
                              ),
                            ),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceElevated,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.favorite_border_rounded,
                                  color: AppTheme.textPrimary,
                                  size: 20,
                                ),
                              ),
                              if (provider.favorites.isNotEmpty)
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppTheme.gold,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      provider.favorites.length.toString(),
                                      style: GoogleFonts.jost(
                                        color: AppTheme.background,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Saved Recommendations Button
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SavedRecommendationsScreen(),
                            ),
                          ),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.bookmark_border_rounded,
                              color: AppTheme.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Profile Button
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          ),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              color: AppTheme.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  itemCount: _filterCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _filterCategories[index];
                    return CategoryChip(
                      label: cat,
                      isSelected: provider.selectedCategory == cat,
                      onTap: () => provider.setCategory(cat),
                    );
                  },
                ),
              ),
            ),

            // Quote count
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
                child: Text(
                  '${quotes.length} ${quotes.length == 1 ? 'quote' : 'quotes'}',
                  style: GoogleFonts.jost(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            // Empty state
            if (quotes.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      Text(
                        '❝',
                        style: TextStyle(
                          fontSize: 48,
                          color: AppTheme.textSecondary.withAlpha(77),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        provider.selectedCategory == 'All'
                            ? 'No quotes yet'
                            : 'No ${provider.selectedCategory} quotes',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your first quote to begin',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

            // Quotes list
            if (quotes.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index.isOdd) return const SizedBox(height: 16);
                    return QuoteCard(quote: quotes[index ~/ 2]);
                  }, childCount: quotes.length * 2 - 1),
                ),
              ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AddEditQuoteScreen(),
            transitionsBuilder: (_, anim, __, child) => SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                  ),
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        ),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppTheme.gold,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: AppTheme.gold.withAlpha(77),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, color: AppTheme.background, size: 20),
              const SizedBox(width: 8),
              Text(
                'ADD QUOTE',
                style: GoogleFonts.jost(
                  color: AppTheme.background,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
