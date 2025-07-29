import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onSplashComplete;

  const SplashScreen({
    super.key,
    required this.onSplashComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  void _startSplashSequence() async {
    // Start animations
    await _animationController.forward();
    
    // Wait for splash duration
    await Future.delayed(AppConstants.splashDuration);
    
    // Fade out and navigate
    await _animationController.reverse();
    
    // Call the callback to navigate to dashboard
    widget.onSplashComplete();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lottie Animation
                    Container(
                      width: 200,
                      height: 200,
                      child: Lottie.asset(
                        'assets/animations/energy_flow.json',
                        fit: BoxFit.contain,
                        onLoaded: (composition) {
                          // Animation loaded successfully
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to a simple animated icon if Lottie fails
                          return _buildFallbackAnimation();
                        },
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.largePadding),
                    
                    // App Logo/Title
                    Column(
                      children: [
                        Text(
                          AppConstants.appName,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Text(
                          AppConstants.appDescription,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondaryColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.largePadding * 2),
                    
                    // Loading indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallbackAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: Icon(
            Icons.electric_bolt,
            size: 100,
            color: AppTheme.primaryColor.withOpacity(0.8),
          ),
        );
      },
    );
  }
} 