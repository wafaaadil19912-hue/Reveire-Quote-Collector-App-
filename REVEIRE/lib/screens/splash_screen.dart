import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _lineAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _slideController, curve: Curves.easeOut));
    _lineAnim = CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.gold.withValues(alpha: 0.06),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppTheme.gold.withValues(alpha: 0.5),
                            width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text('❝',
                            style: TextStyle(
                                fontSize: 32, color: AppTheme.gold)),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text('REVERIE',
                        style: GoogleFonts.jost(
                          color: AppTheme.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 8,
                        )),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _lineAnim,
                      builder: (_, __) => Container(
                        width: 60 * _lineAnim.value,
                        height: 1,
                        color: AppTheme.gold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('Your personal quote sanctuary',
                        style: GoogleFonts.cormorantGaramond(
                          color: AppTheme.textSecondary,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.5,
                        )),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'COLLECT · REFLECT · INSPIRE',
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(
                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                  fontSize: 10,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}